var mis_piezas = new Array();
var incognitas = new Array();
var abiertas = new Array(); 
var countPiezasCont;

function agregaFichas(ficha){
    var claseFicha = ficha[0].toString() + ficha[1].toString();
    var formatoFicha = ficha[0].toString() + ',' + ficha[1].toString();
    $(".contPiezas").append('<li class="'+claseFicha+'">'+formatoFicha+'</li>');
}
function eliminaMisFichas(ficha){
    $("."+ficha[0].toString()+ficha[1].toString()).remove();
}
function agregaMiTiro(ficha){
    $(".miTiro").empty();
    var formatoFicha = ficha[0].toString() + ',' + ficha[1].toString();
    $(".miTiro").append(formatoFicha);
}

function eliminaPieza(lista,pieza){
    var aux = 0;var flag = false;
    while(aux < lista.lenght && !flag){
        if(lista[aux][0]==pieza[0] && lista[aux][1] == pieza[1]){
            lista.splice(aux,1);
            flag = true;
        }else{
            aux++;
        }
    }
}

function actualizaAbiertas(tiro){
    var aux = new Array()
    if(abiertas[0]==tiro[0]){
        aux[0] = abiertas[1];
        aux[1] = tiro[1];
    }else{
        if(abiertas[1]==tiro[0]){
            aux[0] = abiertas[0];
            aux[1] = tiro[1];
        }else{
            if(abiertas[1]==tiro[1]){
                aux[0] = tiro[0];
                aux[1] = abiertas[0];
            }else{
                aux[0] = abiertas[1];
                aux[1] = tiro[0];
            }
        }
        
    }
    abiertas = ordenaPiezas(aux);

}

function ordenaPiezas(pieza){
    if( pieza[0] < pieza[1]){
        pieza = [pieza[1],pieza[0]];
    };
    return pieza;
}

function actualizaMisFichas(ficha){
    console.log(ficha);
    piezaOrd = ordenaPiezas(ficha);
    eliminaPieza(mis_piezas,piezaOrd);
    actualizaAbiertas(piezaOrd);
    eliminaMisFichas(piezaOrd);
    agregaMiTiro(ficha);
    if(mis_piezas.length == 0){
        Swal.fire(
            'Felicidades!',
            'Ganaste la partida!',
            'success'
          )
    }
}

$('.btn-success').click(function() {
    tiroJugador();
  });

$('.btn-danger').click(function() {
    tiroContrario();
  });

$('.btn-dark').click(function() {
    newGame();
  });


function newGame(){
    incognitas = [[6,6],[6,5],[6,4],[6,3],[6,2],[6,1],[6,0],[5,5],[5,4],[5,3],[5,2],[5,3],[5,4],[5,2],[5,1],[5,0],[4,4],[4,3],[4,2],[4,1],[4,0],[3,3],[3,2],[3,1],[3,0],[2,2],[2,1],[2,0],[1,1],[1,0],[0,0]];
    countPiezasCont = 7;
    $('.btn-success').attr('disabled',false);
    $('.btn-danger').attr('disabled',false);
    $(".contPiezas").empty();
    $(".miTiro").empty();
    Swal.mixin({
        input: 'text',
        confirmButtonText: 'Siguiente &rarr;',
        progressSteps: ['1', '2', '3','4','5','6','7']
        }).queue([
        {
            title: 'Pieza 1',
            text: 'Introduzca las piezas con las que inicio el juego con el formato x,y'
        },
        'Pieza 2',
        'Pieza 3',
        'Pieza 4',
        'Pieza 5',
        'Pieza 6',
        'Pieza 7'
        ]).then((result) => {
        if (result.value) {
                result.value.forEach(piezaS => {
                    pieza = [parseInt(piezaS.substring(0,1)),parseInt(piezaS.substring(2))];
                    piezaOrd = ordenaPiezas(pieza);
                    mis_piezas.push(piezaOrd);
                    eliminaPieza(incognitas,piezaOrd);
                    agregaFichas(piezaOrd);
            });
            primerTiro();
        }
    })
};



function primerTiro(){
    Swal.fire({
        title: '¿Quién realizo el primer tiro?',
        type: 'question',
        showCancelButton: true,
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yo',
        cancelButtonText: 'Contrincante'
    }).then((result) => {
        if (result.value) {
            Swal.fire({
                title: '¿Qué pieza?',
                input: 'text',
                confirmButtonText: 'Aceptar',
                text: 'Introduzca la pieza con el formato x,y'
            }).then((result) => {
                if (result.value) {
                    pieza = [parseInt(result.value.substring(0,1)),parseInt(result.value.substring(2))];
                    piezaOrd = ordenaPiezas(pieza);
                    agregaMiTiro(pieza);
                    eliminaPieza(mis_piezas,piezaOrd);
                    abiertas = piezaOrd;
                    eliminaMisFichas(piezaOrd);
                }
            })
        }else{
            Swal.fire({
                title: '¿Qué pieza?',
                input: 'text',
                confirmButtonText: 'Aceptar',
                text: 'Introduzca la pieza con el formato x,y'
            }).then((result) => {
                if (result.value) {
                    pieza = [parseInt(result.value.substring(0,1)),parseInt(result.value.substring(2))];
                    piezaOrd = ordenaPiezas(pieza);
                    eliminaPieza(incognitas,piezaOrd);
                    abiertas = piezaOrd;
                    countPiezasCont--;
                }
            })
        }
    });
}

function tiroContrario(){
    Swal.fire({
        title: '¿El contrincante comió piezas?',
        type: 'question',
        showCancelButton: true,
        cancelButtonColor: '#d33',
        confirmButtonText: 'Sí',
        cancelButtonText: 'No'
      }).then((result) => {
        if (result.value) {
          Swal.fire({
            title: '¿Cuántas piezas comió?',
            input: 'text',
            confirmButtonText: 'Aceptar'
          }).then((result) => {
            if (result.value) {
                countPiezasCont = countPiezasCont + parseInt(result.value[0].substring(0));
                Swal.fire({
                    title: '¿El contrincante tiró alguna pieza?',
                    type: 'question',
                    showCancelButton: true,
                    cancelButtonColor: '#d33',
                    confirmButtonText: 'Sí',
                    cancelButtonText: 'No'
                }).then((result) => {
                    if (result.value) {
                    Swal.fire({
                        title: '¿Qué pieza?',
                        input: 'text',
                        confirmButtonText: 'Aceptar',
                        text: 'Introduzca la pieza con el formato x,y donde y es el lado de la pieza que queda abierto.'
                    }).then((result) => {
                        if (result.value) {
                            pieza = [parseInt(result.value.substring(0,1)),parseInt(result.value.substring(2))];
                            piezaOrd = ordenaPiezas(pieza);
                            eliminaPieza(incognitas,piezaOrd);
                            actualizaAbiertas(piezaOrd);
                            countPiezasCont--;
                        }
                    })
                    }
                });
            }
          })
        }else{
            Swal.fire({
                title: '¿El contrincante tiró alguna pieza?',
                type: 'question',
                showCancelButton: true,
                cancelButtonColor: '#d33',
                confirmButtonText: 'Sí',
                cancelButtonText: 'No'
            }).then((result) => {
                if (result.value) {
                Swal.fire({
                    title: '¿Qué pieza?',
                    input: 'text',
                    confirmButtonText: 'Aceptar',
                    text: 'Introduzca la pieza con el formato x,y donde y es el lado de la pieza que queda abierto.'
                }).then((result) => {
                    if (result.value) {
                        pieza = [parseInt(result.value.substring(0,1)),parseInt(result.value.substring(2))];
                        piezaOrd = ordenaPiezas(pieza);
                        eliminaPieza(incognitas,piezaOrd);
                        actualizaAbiertas(piezaOrd);
                        countPiezasCont--;
                        if(countPiezasCont==0){
                            Swal.fire(
                                ':(',
                                'Has perdido la partida',
                                'error'
                              )
                        }
                    }
                })
                }
            });
        }
      });

};


function tiroJugador(){
    var posibleTiro = false;
    
    mis_piezas.forEach(pieza  =>{
        if(pieza[0]==abiertas[0] || pieza[0]==abiertas[1] || pieza[1]==abiertas[0] || pieza[1]==abiertas[1]){
            posibleTiro = true;
        }
    });
    
    if(posibleTiro){
        ejecutarAlphaBeta();
     }else{
        if((incognitas.length-countPiezasCont)>0){
            Swal.fire({
                title: 'No tienes ninguna pieza para tirar, debes de comer.',
                text: "Indica cuántas fichas comiste",
                input: 'text',
                confirmButtonText: 'Aceptar'
            }).then((result) => {
                    if (result.value) {
                        fichasComidas(parseInt(result.value));
                    }
                })
        }else{
            Swal.fire({
                type: 'error',
                title: 'Oops...',
                text: 'No puedes realizar ningún tiro!'
            })
        }
        
    }
};

function ejecutarAlphaBeta(){
    var param={
        misPiezas:mis_piezas,
        incognitas:incognitas,
        abiertas:abiertas,
        depth:5,
        countPiezasCont:countPiezasCont
    };
    $.post("http://95.216.205.0/AlphaBeta.php",JSON.stringify(param),function(data1,status){
        if(data1[0]!="Sin fichas disponibles"){
            actualizaMisFichas(data1[0]);
        }else{
            param.depth = 4;
            $.post("http://95.216.205.0/AlphaBeta.php",JSON.stringify(param),function(data2,status){
                if(data2[0]!="Sin fichas disponibles"){
                    actualizaMisFichas(data2[0]);
                }else{
                    param.depth = 3;
                    $.post("http://95.216.205.0/AlphaBeta.php",JSON.stringify(param),function(data3,status){
                        if(data3[0]!="Sin fichas disponibles"){
                            actualizaMisFichas(data3[0]);
                        }else{
                            param.depth = 2;
                            $.post("http://95.216.205.0/AlphaBeta.php",JSON.stringify(param),function(data4,status){
                                if(data4[0]!="Sin fichas disponibles"){
                                    actualizaMisFichas(data4[0]);
                                }else{
                                    param.depth = 1;
                                    $.post("http://95.216.205.0/AlphaBeta.php",JSON.stringify(param),function(data5,status){
                                        actualizaMisFichas(data5[0]);
                                    }),"json";
                                }
                            },"json");
                        }
                    },"json");
                }
            },"json");
        }
    },"json");
}




function fichasComidas(value){
    switch(value) {
        case 1:
            Swal.mixin({
                input: 'text',
                confirmButtonText: 'Siguiente &rarr;',
                progressSteps: ['1']
                }).queue([
                {
                    title: 'Pieza 1',
                    text: 'Introduzca las piezas que comió con el formato x,y'
                }
                ]).then((result) => {
                if (result.value) {
                    result.value.forEach(piezaS => {
                        pieza = [parseInt(piezaS.substring(0,1)),parseInt(piezaS.substring(2))];
                        piezaOrd = ordenaPiezas(pieza);
                        if(piezaOrd[0]==abiertas[0] || piezaOrd[1]==abiertas[1]){
                            if(piezaOrd[0]==abiertas[0] && piezpiezaOrda[1]==abiertas[1]){
                                ejecutarAlphaBeta();
                            }else{
                                var miTiro = piezaOrd[0]==abiertas[0] ? piezaOrd:[piezaOrd[1],piezaOrd[0]];
                                agregaMiTiro(miTiro);
                            }
                        }else{
                            mis_piezas.push(piezaOrd);
                            agregaFichas(piezaOrd);
                        }
                        eliminaPieza(incognitas,piezaOrd);
                    });
                }
            })
          break;
        case 2:
            Swal.mixin({
                input: 'text',
                confirmButtonText: 'Siguiente &rarr;',
                progressSteps: ['1', '2']
                }).queue([
                {
                    title: 'Pieza 1',
                    text: 'Introduzca las piezas que comió con el formato x,y'
                },
                'Pieza 2'
                ]).then((result) => {
                if (result.value) {
                    result.value.forEach(piezaS => {
                        pieza = [parseInt(piezaS.substring(0,1)),parseInt(piezaS.substring(2))];
                        piezaOrd = ordenaPiezas(pieza);
                        if(piezaOrd[0]==abiertas[0] || piezaOrd[1]==abiertas[1]){
                            if(piezaOrd[0]==abiertas[0] && piezpiezaOrda[1]==abiertas[1]){
                                ejecutarAlphaBeta();
                            }else{
                                var miTiro = piezaOrd[0]==abiertas[0] ? piezaOrd:[piezaOrd[1],piezaOrd[0]];
                                agregaMiTiro(miTiro);
                            }
                        }else{
                            mis_piezas.push(piezaOrd);
                            agregaFichas(piezaOrd);
                        }
                        eliminaPieza(incognitas,piezaOrd);
                    });
                }
            })
          break;
        case 3:
            Swal.mixin({
                input: 'text',
                confirmButtonText: 'Siguiente &rarr;',
                progressSteps: ['1', '2', '3']
                }).queue([
                {
                    title: 'Pieza 1',
                    text: 'Introduzca las piezas que comió con el formato x,y'
                },
                'Pieza 2',
                'Pieza 3'
                ]).then((result) => {
                if (result.value) {
                    result.value.forEach(piezaS => {
                        pieza = [parseInt(piezaS.substring(0,1)),parseInt(piezaS.substring(2))];
                        piezaOrd = ordenaPiezas(pieza);
                        if(pieza[0]==abiertas[0] || pieza[1]==abiertas[0] || pieza[0]==abiertas[1] || pieza[1]==abiertas[1]){
                            actualizaAbiertas(piezaOrd);
                            //En este caso se tiene que validar si se puede tirar hacia los dos lados
                            agregaMiTiro(piezaOrd);
                        }else{
                            mis_piezas.push(piezaOrd);
                            agregaFichas(piezaOrd);
                        }
                        eliminaPieza(incognitas,piezaOrd);
                    });
                }
            })
          break;
        case 4:
            Swal.mixin({
                input: 'text',
                confirmButtonText: 'Siguiente &rarr;',
                progressSteps: ['1', '2', '3','4']
                }).queue([
                {
                    title: 'Pieza 1',
                    text: 'Introduzca las piezas que comió con el formato x,y'
                },
                'Pieza 2',
                'Pieza 3',
                'Pieza 4'
                ]).then((result) => {
                if (result.value) {
                    result.value.forEach(piezaS => {
                        pieza = [parseInt(piezaS.substring(0,1)),parseInt(piezaS.substring(2))];
                        piezaOrd = ordenaPiezas(pieza);
                        if(piezaOrd[0]==abiertas[0] || piezaOrd[1]==abiertas[1]){
                            if(piezaOrd[0]==abiertas[0] && piezpiezaOrda[1]==abiertas[1]){
                                ejecutarAlphaBeta();
                            }else{
                                var miTiro = piezaOrd[0]==abiertas[0] ? piezaOrd:[piezaOrd[1],piezaOrd[0]];
                                agregaMiTiro(miTiro);
                            }
                        }else{
                            mis_piezas.push(piezaOrd);
                            agregaFichas(piezaOrd);
                        }
                        eliminaPieza(incognitas,piezaOrd);
                    });
                }
            })
          break;
        case 5:
            Swal.mixin({
                input: 'text',
                confirmButtonText: 'Siguiente &rarr;',
                progressSteps: ['1', '2', '3','4','5']
                }).queue([
                {
                    title: 'Pieza 1',
                    text: 'Introduzca las piezas que comió con el formato x,y'
                },
                'Pieza 2',
                'Pieza 3',
                'Pieza 4',
                'Pieza 5'
                ]).then((result) => {
                if (result.value) {
                    result.value.forEach(piezaS => {
                        pieza = [parseInt(piezaS.substring(0,1)),parseInt(piezaS.substring(2))];
                        piezaOrd = ordenaPiezas(pieza);
                        if(piezaOrd[0]==abiertas[0] || piezaOrd[1]==abiertas[1]){
                            if(piezaOrd[0]==abiertas[0] && piezpiezaOrda[1]==abiertas[1]){
                                ejecutarAlphaBeta();
                            }else{
                                var miTiro = piezaOrd[0]==abiertas[0] ? piezaOrd:[piezaOrd[1],piezaOrd[0]];
                                agregaMiTiro(miTiro);
                            }
                        }else{
                            mis_piezas.push(piezaOrd);
                            agregaFichas(piezaOrd);
                        }
                        eliminaPieza(incognitas,piezaOrd);
                    });
                }
            })
          break;
        case 6:
            Swal.mixin({
                input: 'text',
                confirmButtonText: 'Siguiente &rarr;',
                progressSteps: ['1', '2', '3','4','5','6']
                }).queue([
                {
                    title: 'Pieza 1',
                    text: 'Introduzca las piezas que comió con el formato x,y'
                },
                'Pieza 2',
                'Pieza 3',
                'Pieza 4',
                'Pieza 5',
                'Pieza 6'
                ]).then((result) => {
                if (result.value) {
                    result.value.forEach(piezaS => {
                        pieza = [parseInt(piezaS.substring(0,1)),parseInt(piezaS.substring(2))];
                        piezaOrd = ordenaPiezas(pieza);
                        if(piezaOrd[0]==abiertas[0] || piezaOrd[1]==abiertas[1]){
                            if(piezaOrd[0]==abiertas[0] && piezpiezaOrda[1]==abiertas[1]){
                                ejecutarAlphaBeta();
                            }else{
                                var miTiro = piezaOrd[0]==abiertas[0] ? piezaOrd:[piezaOrd[1],piezaOrd[0]];
                                agregaMiTiro(miTiro);
                            }
                        }else{
                            mis_piezas.push(piezaOrd);
                            agregaFichas(piezaOrd);
                        }
                        eliminaPieza(incognitas,piezaOrd);
                    });
                }
            })
          break;
        case 7:
            Swal.mixin({
                input: 'text',
                confirmButtonText: 'Siguiente &rarr;',
                progressSteps: ['1', '2', '3','4','5','6','7']
                }).queue([
                {
                    title: 'Pieza 1',
                    text: 'Introduzca las piezas que comió con el formato x,y'
                },
                'Pieza 2',
                'Pieza 3',
                'Pieza 4',
                'Pieza 5',
                'Pieza 6',
                'Pieza 7'
                ]).then((result) => {
                if (result.value) {
                    result.value.forEach(piezaS => {
                        pieza = [parseInt(piezaS.substring(0,1)),parseInt(piezaS.substring(2))];
                        piezaOrd = ordenaPiezas(pieza);
                        if(piezaOrd[0]==abiertas[0] || piezaOrd[1]==abiertas[1]){
                            if(piezaOrd[0]==abiertas[0] && piezpiezaOrda[1]==abiertas[1]){
                                ejecutarAlphaBeta();
                            }else{
                                var miTiro = piezaOrd[0]==abiertas[0] ? piezaOrd:[piezaOrd[1],piezaOrd[0]];
                                agregaMiTiro(miTiro);
                            }
                        }else{
                            mis_piezas.push(piezaOrd);
                            agregaFichas(piezaOrd);
                        }
                        eliminaPieza(incognitas,piezaOrd);
                    });
                }
            })
          break;
        case 8:
            Swal.mixin({
                input: 'text',
                confirmButtonText: 'Siguiente &rarr;',
                progressSteps: ['1', '2', '3','4','5','6','7','8']
                }).queue([
                {
                    title: 'Pieza 1',
                    text: 'Introduzca las piezas que comió con el formato x,y'
                },
                'Pieza 2',
                'Pieza 3',
                'Pieza 4',
                'Pieza 5',
                'Pieza 6',
                'Pieza 7',
                'Pieza 8'
                ]).then((result) => {
                if (result.value) {
                    result.value.forEach(piezaS => {
                        pieza = [parseInt(piezaS.substring(0,1)),parseInt(piezaS.substring(2))];
                        piezaOrd = ordenaPiezas(pieza);
                        if(piezaOrd[0]==abiertas[0] || piezaOrd[1]==abiertas[1]){
                            if(piezaOrd[0]==abiertas[0] && piezpiezaOrda[1]==abiertas[1]){
                                ejecutarAlphaBeta();
                            }else{
                                var miTiro = piezaOrd[0]==abiertas[0] ? piezaOrd:[piezaOrd[1],piezaOrd[0]];
                                agregaMiTiro(miTiro);
                            }
                        }else{
                            mis_piezas.push(piezaOrd);
                            agregaFichas(piezaOrd);
                        }
                        eliminaPieza(incognitas,piezaOrd);
                    });
                }
            })
          break;
        case 9:
            Swal.mixin({
                input: 'text',
                confirmButtonText: 'Siguiente &rarr;',
                progressSteps: ['1', '2', '3','4','5','6','7','8','9']
                }).queue([
                {
                    title: 'Pieza 1',
                    text: 'Introduzca las piezas que comió con el formato x,y'
                },
                'Pieza 2',
                'Pieza 3',
                'Pieza 4',
                'Pieza 5',
                'Pieza 6',
                'Pieza 7',
                'Pieza 8',
                'Pieza 9'
                ]).then((result) => {
                if (result.value) {
                    result.value.forEach(piezaS => {
                        pieza = [parseInt(piezaS.substring(0,1)),parseInt(piezaS.substring(2))];
                        piezaOrd = ordenaPiezas(pieza);
                        if(piezaOrd[0]==abiertas[0] || piezaOrd[1]==abiertas[1]){
                            if(piezaOrd[0]==abiertas[0] && piezpiezaOrda[1]==abiertas[1]){
                                ejecutarAlphaBeta();
                            }else{
                                var miTiro = piezaOrd[0]==abiertas[0] ? piezaOrd:[piezaOrd[1],piezaOrd[0]];
                                agregaMiTiro(miTiro);
                            }
                        }else{
                            mis_piezas.push(piezaOrd);
                            agregaFichas(piezaOrd);
                        }
                        eliminaPieza(incognitas,piezaOrd);
                    });
                }
            })
          break;
        case 10:
            Swal.mixin({
                input: 'text',
                confirmButtonText: 'Siguiente &rarr;',
                progressSteps: ['1', '2', '3','4','5','6','7','8','9','10']
                }).queue([
                {
                    title: 'Pieza 1',
                    text: 'Introduzca las piezas que comió con el formato x,y'
                },
                'Pieza 2',
                'Pieza 3',
                'Pieza 4',
                'Pieza 5',
                'Pieza 6',
                'Pieza 7',
                'Pieza 8',
                'Pieza 9',
                'Pieza 10'
                ]).then((result) => {
                if (result.value) {
                    result.value.forEach(piezaS => {
                        pieza = [parseInt(piezaS.substring(0,1)),parseInt(piezaS.substring(2))];
                        piezaOrd = ordenaPiezas(pieza);
                        if(piezaOrd[0]==abiertas[0] || piezaOrd[1]==abiertas[1]){
                            if(piezaOrd[0]==abiertas[0] && piezpiezaOrda[1]==abiertas[1]){
                                ejecutarAlphaBeta();
                            }else{
                                var miTiro = piezaOrd[0]==abiertas[0] ? piezaOrd:[piezaOrd[1],piezaOrd[0]];
                                agregaMiTiro(miTiro);
                            }
                        }else{
                            mis_piezas.push(piezaOrd);
                            agregaFichas(piezaOrd);
                        }
                        eliminaPieza(incognitas,piezaOrd);
                    });
                }
            })
          break;
        case 11:
            Swal.mixin({
                input: 'text',
                confirmButtonText: 'Siguiente &rarr;',
                progressSteps: ['1', '2', '3','4','5','6','7','8','9','10','11']
                }).queue([
                {
                    title: 'Pieza 1',
                    text: 'Introduzca las piezas que comió con el formato x,y'
                },
                'Pieza 2',
                'Pieza 3',
                'Pieza 4',
                'Pieza 5',
                'Pieza 6',
                'Pieza 7',
                'Pieza 8',
                'Pieza 9',
                'Pieza 10',
                'Pieza 11'
                ]).then((result) => {
                if (result.value) {
                    result.value.forEach(piezaS => {
                        pieza = [parseInt(piezaS.substring(0,1)),parseInt(piezaS.substring(2))];
                        piezaOrd = ordenaPiezas(pieza);
                        if(piezaOrd[0]==abiertas[0] || piezaOrd[1]==abiertas[1]){
                            if(piezaOrd[0]==abiertas[0] && piezpiezaOrda[1]==abiertas[1]){
                                ejecutarAlphaBeta();
                            }else{
                                var miTiro = piezaOrd[0]==abiertas[0] ? piezaOrd:[piezaOrd[1],piezaOrd[0]];
                                agregaMiTiro(miTiro);
                            }
                        }else{
                            mis_piezas.push(piezaOrd);
                            agregaFichas(piezaOrd);
                        }
                        eliminaPieza(incognitas,piezaOrd);
                    });
                }
            })
          break;
        case 12:
            Swal.mixin({
                input: 'text',
                confirmButtonText: 'Siguiente &rarr;',
                progressSteps: ['1', '2', '3','4','5','6','7','8','9','10','11','12']
                }).queue([
                {
                    title: 'Pieza 1',
                    text: 'Introduzca las piezas que comió con el formato x,y'
                },
                'Pieza 2',
                'Pieza 3',
                'Pieza 4',
                'Pieza 5',
                'Pieza 6',
                'Pieza 7',
                'Pieza 8',
                'Pieza 9',
                'Pieza 10',
                'Pieza 11',
                'Pieza 12'
                ]).then((result) => {
                if (result.value) {
                    result.value.forEach(piezaS => {
                        pieza = [parseInt(piezaS.substring(0,1)),parseInt(piezaS.substring(2))];
                        piezaOrd = ordenaPiezas(pieza);
                        if(piezaOrd[0]==abiertas[0] || piezaOrd[1]==abiertas[1]){
                            if(piezaOrd[0]==abiertas[0] && piezpiezaOrda[1]==abiertas[1]){
                                ejecutarAlphaBeta();
                            }else{
                                var miTiro = piezaOrd[0]==abiertas[0] ? piezaOrd:[piezaOrd[1],piezaOrd[0]];
                                agregaMiTiro(miTiro);
                            }
                        }else{
                            mis_piezas.push(piezaOrd);
                            agregaFichas(piezaOrd);
                        }
                        eliminaPieza(incognitas,piezaOrd);
                    });
                }
            })
          break;
        case 13:
            Swal.mixin({
                input: 'text',
                confirmButtonText: 'Siguiente &rarr;',
                progressSteps: ['1', '2', '3','4','5','6','7','8','9','10','11','12','13']
                }).queue([
                {
                    title: 'Pieza 1',
                    text: 'Introduzca las piezas que comió con el formato x,y'
                },
                'Pieza 2',
                'Pieza 3',
                'Pieza 4',
                'Pieza 5',
                'Pieza 6',
                'Pieza 7',
                'Pieza 8',
                'Pieza 9',
                'Pieza 10',
                'Pieza 11',
                'Pieza 12',
                'Pieza 13'
                ]).then((result) => {
                if (result.value) {
                    result.value.forEach(piezaS => {
                        pieza = [parseInt(piezaS.substring(0,1)),parseInt(piezaS.substring(2))];
                        piezaOrd = ordenaPiezas(pieza);
                        if(piezaOrd[0]==abiertas[0] || piezaOrd[1]==abiertas[1]){
                            if(piezaOrd[0]==abiertas[0] && piezpiezaOrda[1]==abiertas[1]){
                                ejecutarAlphaBeta();
                            }else{
                                var miTiro = piezaOrd[0]==abiertas[0] ? piezaOrd:[piezaOrd[1],piezaOrd[0]];
                                agregaMiTiro(miTiro);
                            }
                        }else{
                            mis_piezas.push(piezaOrd);
                            agregaFichas(piezaOrd);
                        }
                        eliminaPieza(incognitas,piezaOrd);
                    });
                }
            })
          break;
        case 14:
            Swal.mixin({
                input: 'text',
                confirmButtonText: 'Siguiente &rarr;',
                progressSteps: ['1', '2', '3','4','5','6','7','8','9','10','11','12','13','14']
                }).queue([
                {
                    title: 'Pieza 1',
                    text: 'Introduzca las piezas que comió con el formato x,y'
                },
                'Pieza 2',
                'Pieza 3',
                'Pieza 4',
                'Pieza 5',
                'Pieza 6',
                'Pieza 7',
                'Pieza 8',
                'Pieza 9',
                'Pieza 10',
                'Pieza 11',
                'Pieza 12',
                'Pieza 13',
                'Pieza 14'
                ]).then((result) => {
                if (result.value) {
                    result.value.forEach(piezaS => {
                        pieza = [parseInt(piezaS.substring(0,1)),parseInt(piezaS.substring(2))];
                        piezaOrd = ordenaPiezas(pieza);
                        if(piezaOrd[0]==abiertas[0] || piezaOrd[1]==abiertas[1]){
                            if(piezaOrd[0]==abiertas[0] && piezpiezaOrda[1]==abiertas[1]){
                                ejecutarAlphaBeta();
                            }else{
                                var miTiro = piezaOrd[0]==abiertas[0] ? piezaOrd:[piezaOrd[1],piezaOrd[0]];
                                agregaMiTiro(miTiro);
                            }
                        }else{
                            mis_piezas.push(piezaOrd);
                            agregaFichas(piezaOrd);
                        }
                        eliminaPieza(incognitas,piezaOrd);
                    });
                }
            })
          break;
        default:
          // code block
      }
    
}


