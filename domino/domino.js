var mis_piezas = new Array();
var incognitas = new Array();
var abiertas = new Array(); 
var countPiezasCont;


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
                result.value.forEach(pieza => {
                    piezaN = ordenaPiezas([pieza.substring(0,1),pieza.substring(2)]);
                    mis_piezas.push(piezaN);
                    eliminaPieza(incognitas,piezaN);
                    agregaFichas(piezaN);
            });
            primerTiro();
        }
    })
};

function agregaFichas(ficha){
    $(".contPiezas").append('<li class="'+ficha[0]+' , '+ ficha[1]+'">'+ficha+'</li>');
}
function eliminaMisFichas(ficha){
    $("."+ficha[0].toString()+ficha[1].toString()).remove();
}
function agregaMiTiro(ficha){
    $(".miTiro").empty();
    $(".miTiro").append(ficha);
}

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
                    agregaMiTiro(result.value)
                    eliminaPieza(mis_piezas,[parseInt(result.value.substring(0,1)),parseInt(result.value.substring(2))]);
                    abiertas = [parseInt(result.value.substring(0,1)),parseInt(result.value.substring(2))];
                    piezaN = ordenaPiezas([parseInt(result.value.substring(0,1)),parseInt(result.value.substring(2))])
                    eliminaMisFichas(piezaN);
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
                    eliminaPieza(incognitas,[parseInt(result.value.substring(0,1)),parseInt(result.value.substring(2))]);
                    abiertas = [parseInt(result.value.substring(0,1)),parseInt(result.value.substring(2))];
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
                            eliminaPieza(incognitas,[parseInt(result.value.substring(0,1)),parseInt(result.value.substring(2))]);
                            actualizaAbiertas([parseInt(result.value.substring(0,1)),parseInt(result.value.substring(2))]);
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
                        eliminaPieza(incognitas,[parseInt(result.value.substring(0,1)),parseInt(result.value.substring(2))]);
                        actualizaAbiertas([parseInt(result.value.substring(0,1)),parseInt(result.value.substring(2))]);
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
        //console.log("data1"+data1[0]);
        if(data1[0]!="Sin fichas disponibles"){
            actualizaMisFichas(data1[0]);
        }else{
            param.depth = 4;
            $.post("http://95.216.205.0/AlphaBeta.php",JSON.stringify(param),function(data2,status){
                //console.log(data2);
                if(data2[0]!="Sin fichas disponibles"){
                    actualizaMisFichas(data2[0]);
                }else{
                    param.depth = 3;
                    $.post("http://95.216.205.0/AlphaBeta.php",JSON.stringify(param),function(data3,status){
                        //console.log(data3);
                        if(data3[0]!="Sin fichas disponibles"){
                            actualizaMisFichas(data3[0]);
                        }else{
                            param.depth = 2;
                            $.post("http://95.216.205.0/AlphaBeta.php",JSON.stringify(param),function(data4,status){
                                //console.log(data4);
                                if(data4[0]!="Sin fichas disponibles"){
                                    actualizaMisFichas(data4[0]);
                                }else{
                                    param.depth = 1;
                                    $.post("http://95.216.205.0/AlphaBeta.php",JSON.stringify(param),function(data5,status){
                                        //console.log(data5);
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

function actualizaMisFichas(ficha){
    console.log(ficha);
    fichaN = ordenaPiezas(ficha);
    eliminaPieza(mis_piezas,fichaN);
    actualizaAbiertas([parseInt(ficha[0]),parseInt(ficha[1])]);
    eliminaMisFichas(fichaN);
    agregaMiTiro(fichaN);
    if(mis_piezas.length == 0){
        Swal.fire(
            'Felicidades!',
            'Ganaste la partida!',
            'success'
          )
    }
}


function eliminaPieza(lista,pieza){
    var index = lista.indexOf(pieza);
    if (index == -1){
        pieza = [pieza[1],pieza[0]];
        index = lista.indexOf(pieza);
    }
    lista.splice(index,1);
}

function actualizaAbiertas(tiro)
{
    if(abiertas[0]==tiro[0]){
        abiertas[1] = tiro[1]
    }else{
        abiertas[0] = tiro[1];
    }
}

function ordenaPiezas(pieza){
    if( parseInt(pieza[0]) < parseInt(pieza[1])){
        pieza = [pieza[1],pieza[0]];
    };
    return pieza;
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
                    result.value.forEach(pieza => {
                        if(parseInt(pieza.substring(0,1))==abiertas[0] || parseInt(pieza.substring(2))==abiertas[0] || parseInt(pieza.substring(0,1))==abiertas[1] || parseInt(pieza.substring(2))==abiertas[1]){
                            actualizaAbiertas([parseInt(pieza.substring(0,1)),parseInt(pieza.substring(2))]);
                            agregaMiTiro(pieza);
                        }else{
                            mis_piezas.push([parseInt(pieza.substring(0,1)),parseInt(pieza.substring(2))]);
                            piezaN = ordenaPiezas([parseInt(pieza.substring(0,1)),parseInt(pieza.substring(2))]);
                            agregaFichas(piezaN);
                        }
                        eliminaPieza(incognitas,[parseInt(pieza.substring(0,1)),parseInt(pieza.substring(2))]);
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
                    result.value.forEach(pieza => {
                        if(parseInt(pieza.substring(0,1))==abiertas[0] || parseInt(pieza.substring(2))==abiertas[0] || parseInt(pieza.substring(0,1))==abiertas[1] || parseInt(pieza.substring(2))==abiertas[1]){
                            actualizaAbiertas([parseInt(pieza.substring(0,1)),parseInt(pieza.substring(2))]);
                            agregaMiTiro(pieza);
                        }else{
                            mis_piezas.push([parseInt(pieza.substring(0,1)),parseInt(pieza.substring(2))]);
                            agregaFichas(pieza);
                        }
                        eliminaPieza(incognitas,[parseInt(pieza.substring(0,1)),parseInt(pieza.substring(2))]);
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
                    result.value.forEach(pieza => {
                        if(parseInt(pieza.substring(0,1))==abiertas[0] || parseInt(pieza.substring(2))==abiertas[0] || parseInt(pieza.substring(0,1))==abiertas[1] || parseInt(pieza.substring(2))==abiertas[1]){
                            actualizaAbiertas([parseInt(pieza.substring(0,1)),parseInt(pieza.substring(2))]);
                            agregaMiTiro(pieza);
                        }else{
                            mis_piezas.push([parseInt(pieza.substring(0,1)),parseInt(pieza.substring(2))]);
                            agregaFichas(pieza);
                        }
                        eliminaPieza(incognitas,[parseInt(pieza.substring(0,1)),parseInt(pieza.substring(2))]);
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
                    result.value.forEach(pieza => {
                        if(parseInt(pieza.substring(0,1))==abiertas[0] || parseInt(pieza.substring(2))==abiertas[0] || parseInt(pieza.substring(0,1))==abiertas[1] || parseInt(pieza.substring(2))==abiertas[1]){
                            actualizaAbiertas([parseInt(pieza.substring(0,1)),parseInt(pieza.substring(2))]);
                            agregaMiTiro(pieza);
                        }else{
                            mis_piezas.push([parseInt(pieza.substring(0,1)),parseInt(pieza.substring(2))]);
                            agregaFichas(pieza);
                        }
                        eliminaPieza(incognitas,[parseInt(pieza.substring(0,1)),parseInt(pieza.substring(2))]);
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
                    result.value.forEach(pieza => {
                        if(parseInt(pieza.substring(0,1))==abiertas[0] || parseInt(pieza.substring(2))==abiertas[0] || parseInt(pieza.substring(0,1))==abiertas[1] || parseInt(pieza.substring(2))==abiertas[1]){
                            actualizaAbiertas([parseInt(pieza.substring(0,1)),parseInt(pieza.substring(2))]);
                            agregaMiTiro(pieza);
                        }else{
                            mis_piezas.push([parseInt(pieza.substring(0,1)),parseInt(pieza.substring(2))]);
                            agregaFichas(pieza);
                        }
                        eliminaPieza(incognitas,[parseInt(pieza.substring(0,1)),parseInt(pieza.substring(2))]);
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
                    result.value.forEach(pieza => {
                        if(parseInt(pieza.substring(0,1))==abiertas[0] || parseInt(pieza.substring(2))==abiertas[0] || parseInt(pieza.substring(0,1))==abiertas[1] || parseInt(pieza.substring(2))==abiertas[1]){
                            actualizaAbiertas([parseInt(pieza.substring(0,1)),parseInt(pieza.substring(2))]);
                            agregaMiTiro(pieza);
                        }else{
                            mis_piezas.push([parseInt(pieza.substring(0,1)),parseInt(pieza.substring(2))]);
                            agregaFichas(pieza);
                        }
                        eliminaPieza(incognitas,[parseInt(pieza.substring(0,1)),parseInt(pieza.substring(2))]);
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
                    result.value.forEach(pieza => {
                        if(parseInt(pieza.substring(0,1))==abiertas[0] || parseInt(pieza.substring(2))==abiertas[0] || parseInt(pieza.substring(0,1))==abiertas[1] || parseInt(pieza.substring(2))==abiertas[1]){
                            actualizaAbiertas([parseInt(pieza.substring(0,1)),parseInt(pieza.substring(2))]);
                            agregaMiTiro(pieza);
                        }else{
                            mis_piezas.push([parseInt(pieza.substring(0,1)),parseInt(pieza.substring(2))]);
                            agregaFichas(pieza);
                        }
                        eliminaPieza(incognitas,[parseInt(pieza.substring(0,1)),parseInt(pieza.substring(2))]);
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
                    result.value.forEach(pieza => {
                        if(parseInt(pieza.substring(0,1))==abiertas[0] || parseInt(pieza.substring(2))==abiertas[0] || parseInt(pieza.substring(0,1))==abiertas[1] || parseInt(pieza.substring(2))==abiertas[1]){
                            actualizaAbiertas([parseInt(pieza.substring(0,1)),parseInt(pieza.substring(2))]);
                            agregaMiTiro(pieza);
                        }else{
                            mis_piezas.push([parseInt(pieza.substring(0,1)),parseInt(pieza.substring(2))]);
                            agregaFichas(pieza);
                        }
                        eliminaPieza(incognitas,[parseInt(pieza.substring(0,1)),parseInt(pieza.substring(2))]);
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
                    result.value.forEach(pieza => {
                        if(parseInt(pieza.substring(0,1))==abiertas[0] || parseInt(pieza.substring(2))==abiertas[0] || parseInt(pieza.substring(0,1))==abiertas[1] || parseInt(pieza.substring(2))==abiertas[1]){
                            actualizaAbiertas([parseInt(pieza.substring(0,1)),parseInt(pieza.substring(2))]);
                            agregaMiTiro(pieza);
                        }else{
                            mis_piezas.push([parseInt(pieza.substring(0,1)),parseInt(pieza.substring(2))]);
                            agregaFichas(pieza);
                        }
                        eliminaPieza(incognitas,[parseInt(pieza.substring(0,1)),parseInt(pieza.substring(2))]);
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
                    result.value.forEach(pieza => {
                        if(parseInt(pieza.substring(0,1))==abiertas[0] || parseInt(pieza.substring(2))==abiertas[0] || parseInt(pieza.substring(0,1))==abiertas[1] || parseInt(pieza.substring(2))==abiertas[1]){
                            actualizaAbiertas([parseInt(pieza.substring(0,1)),parseInt(pieza.substring(2))]);
                            agregaMiTiro(pieza);
                        }else{
                            mis_piezas.push([parseInt(pieza.substring(0,1)),parseInt(pieza.substring(2))]);
                            agregaFichas(pieza);
                        }
                        eliminaPieza(incognitas,[parseInt(pieza.substring(0,1)),parseInt(pieza.substring(2))]);
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
                    result.value.forEach(pieza => {
                        if(parseInt(pieza.substring(0,1))==abiertas[0] || parseInt(pieza.substring(2))==abiertas[0] || parseInt(pieza.substring(0,1))==abiertas[1] || parseInt(pieza.substring(2))==abiertas[1]){
                            actualizaAbiertas([parseInt(pieza.substring(0,1)),parseInt(pieza.substring(2))]);
                            agregaMiTiro(pieza);
                        }else{
                            mis_piezas.push([parseInt(pieza.substring(0,1)),parseInt(pieza.substring(2))]);
                            agregaFichas(pieza);
                        }
                        eliminaPieza(incognitas,[parseInt(pieza.substring(0,1)),parseInt(pieza.substring(2))]);
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
                    result.value.forEach(pieza => {
                        if(parseInt(pieza.substring(0,1))==abiertas[0] || parseInt(pieza.substring(2))==abiertas[0] || parseInt(pieza.substring(0,1))==abiertas[1] || parseInt(pieza.substring(2))==abiertas[1]){
                            actualizaAbiertas([parseInt(pieza.substring(0,1)),parseInt(pieza.substring(2))]);
                            agregaMiTiro(pieza);
                        }else{
                            mis_piezas.push([parseInt(pieza.substring(0,1)),parseInt(pieza.substring(2))]);
                            agregaFichas(pieza);
                        }
                        eliminaPieza(incognitas,[parseInt(pieza.substring(0,1)),parseInt(pieza.substring(2))]);
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
                    result.value.forEach(pieza => {
                        if(parseInt(pieza.substring(0,1))==abiertas[0] || parseInt(pieza.substring(2))==abiertas[0] || parseInt(pieza.substring(0,1))==abiertas[1] || parseInt(pieza.substring(2))==abiertas[1]){
                            actualizaAbiertas([parseInt(pieza.substring(0,1)),parseInt(pieza.substring(2))]);
                            agregaMiTiro(pieza);
                        }else{
                            mis_piezas.push([parseInt(pieza.substring(0,1)),parseInt(pieza.substring(2))]);
                            agregaFichas(pieza);
                        }
                        eliminaPieza(incognitas,[parseInt(pieza.substring(0,1)),parseInt(pieza.substring(2))]);
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
                    result.value.forEach(pieza => {
                        if(parseInt(pieza.substring(0,1))==abiertas[0] || parseInt(pieza.substring(2))==abiertas[0] || parseInt(pieza.substring(0,1))==abiertas[1] || parseInt(pieza.substring(2))==abiertas[1]){
                            actualizaAbiertas([parseInt(pieza.substring(0,1)),parseInt(pieza.substring(2))]);
                            agregaMiTiro(pieza);
                        }else{
                            mis_piezas.push([parseInt(pieza.substring(0,1)),parseInt(pieza.substring(2))]);
                            agregaFichas(pieza);
                        }
                        eliminaPieza(incognitas,[parseInt(pieza.substring(0,1)),parseInt(pieza.substring(2))]);
                    });
                }
            })
          break;
        default:
          // code block
      }
    
}


