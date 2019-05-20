var token;
var idIni = '';
var idFin = '';
var songs = new Array();

$.get( "http://95.216.205.0/music_path/authentication.php", function(data) {
    token = data;
  });

$('#button_busqueda').click(function(){
  idIni = $('#idIni').val();
  idFin = $('#idFin').val();
  var param = {"ids":[idIni,idFin],"token":$(".token").text()};
  $.post("http://95.216.205.0/music_path/get_features.php",JSON.stringify(param),function(data){
    jsonData = JSON.parse(data);
    gen = {
      "genIni":{"danceability":jsonData.features[0].danceability,
                "energy":jsonData.features[0].energy,
                "acousticness":jsonData.features[0].acousticness,
                "instrumentalness":jsonData.features[0].instrumentalness,
                "valence":jsonData.features[0].valence
              },
      "genFin":{"danceability":jsonData.features[1].danceability,
              "energy":jsonData.features[1].energy,
              "acousticness":jsonData.features[1].acousticness,
              "instrumentalness":jsonData.features[1].instrumentalness,
              "valence":jsonData.features[1].valence
              }
    };
    $.post("http://95.216.205.0/music_path/get_mutacion.php",JSON.stringify(gen),function(data2){
      var jsonData2 = JSON.parse(data2);
      var aux = 0;
      jsonData2.forEach(song => {
        seed={
          "track_id":idIni+","+idFin,
          "danceability":song.danceability,
          "energy":song.energy,
          "acousticness":song.acousticness,
          "instrumentalness":song.instrumentalness,
          "valence":song.valence,
          "token":$(".token").text()
        };
      
        $.post("http://95.216.205.0/music_path/get_songs.php",JSON.stringify(seed),function(recom){
          jsonRecom = JSON.parse(recom);
          songs.push(jsonRecom.ids);
          if(jsonData2.length-1==aux){
            var delayInMilliseconds = 100; 
            setTimeout(function() {
              constGrafo();
            }, delayInMilliseconds);
          }
          aux++;
        }),"json";
      });
    }),"json";
  }),"json";
});

function constGrafo(){
  songIds= new Array();
  for(var i = 0; i<songs.length;i++){
    for(var j = 0;j<songs[i].length;j++){
      songIds.push(songs[i][j]);
    }
  }
  //songIds.push(idIni);
  //console.log(songIds);
  uniqueIds = new Array();
  $.each(songIds, function(i, el){
    if($.inArray(el, uniqueIds) === -1) uniqueIds.push(el);
  });
  
  var param={
    "token":$(".token").text(),
    "ids":uniqueIds
  }
  $.post("http://95.216.205.0/music_path/get_features.php",JSON.stringify(param),function(nodes){
          var grafo = new Array();
          jsonNodes = JSON.parse(nodes);
          //console.log(jsonNodes);
          var posFin = getIndex(jsonNodes.features);
          for(var i=0;i<jsonNodes.features.length;i++){
            var hijos = new Array();
            /*for(var j=0;j<jsonNodes.features.length;j++){
              if(i!=j){
                var danceabilityD = Math.pow((jsonNodes.features[i].danceability-jsonNodes.features[j].danceability),2);
                var energyD = Math.pow((jsonNodes.features[i].energy-jsonNodes.features[j].energy),2);
                var acousticnessD = Math.pow((jsonNodes.features[i].acousticness-jsonNodes.features[j].acousticness),2);
                var instrumentalnessD = Math.pow((jsonNodes.features[i].instrumentalness-jsonNodes.features[j].instrumentalness),2);
                var valenceD = Math.pow((jsonNodes.features[i].valence-jsonNodes.features[j].valence),2);
                var distancia = Math.sqrt(danceabilityD+energyD+acousticnessD+instrumentalnessD+valenceD).toFixed(3);
                if(distancia<=0.2)
                  hijos.push([jsonNodes.features[j].id,distancia]);
              }
            }*/
            var danceabilityH = Math.pow((jsonNodes.features[i].danceability-jsonNodes.features[posFin].danceability),2);
            var energyH = Math.pow((jsonNodes.features[i].energy-jsonNodes.features[posFin].energy),2);
            var acousticnessH = Math.pow((jsonNodes.features[i].acousticness-jsonNodes.features[posFin].acousticness),2);
            var instrumentalnessH = Math.pow((jsonNodes.features[i].instrumentalness-jsonNodes.features[posFin].instrumentalness),2);
            var valenceH = Math.pow((jsonNodes.features[i].valence-jsonNodes.features[posFin].valence),2);
            var tempoH =  Math.pow((jsonNodes.features[i].tempo-jsonNodes.features[posFin].tempo),2);
            var valorH = Math.sqrt(danceabilityH+energyH+acousticnessH+instrumentalnessH+valenceH+tempoH).toFixed(3);
            grafo.push([jsonNodes.features[i].id,valorH]);
            //console.log(i);
            //console.log(jsonNodes.features[i].id);
            //console.log(grafo);
          }
          var graphOrd = new Array();
          //console.log(grafo);
          //console.log(idIni);
          //var indIni = findNeedle(grafo,idIni);
          //graphOrd[0] = [idIni,100];
          //grafo =grafo.splice(indIni,1);
          var indFin = findNeedle(grafo,idFin);
          var auxFin = grafo[indFin];
          grafo.splice(indFin,1);
          graphOrd=quickSort(grafo);
          //console.log(graphOrd);
          //graphOrd.push(auxFin);
          var graphIds = new Array();
          var aux = 0;
          for(var i=0;i<graphOrd.length;i+=2){
            graphIds[aux]=graphOrd[i];
            aux++;
          }
          
          var graphFinal = new Array();
          graphFinal[0] = idIni;
          max = Math.floor(graphIds.length/2);
          min = Math.floor(graphIds.length/4);
          var nSOngs = getRandomInt(min,max);
          var augment=Math.floor(graphIds.length/nSOngs);
          var auxAug = augment;
          for(var n=1;n<=nSOngs;n++){
            if(graphIds[auxAug]!=idIni && graphIds[auxAug]!=idFin)
              graphFinal[n]=graphIds[auxAug];
            auxAug += augment;
          }
          graphFinal.push(idFin);
          //console.log(graphFinal);
          listaFin={
            token:$(".token").text(),
            ids:graphFinal
          }
          $.post("http://95.216.205.0/music_path/get_tracks.php",JSON.stringify(listaFin),function(listaRes){
              jsonRes = JSON.parse(listaRes);
              var html = '<br>';
              for(var m=0;m<jsonRes.canciones.length;m++){
                html+='<div class="cancion">';
                html+='<img src="'+jsonRes.canciones[m].image_url+'" height="50" width="50">'+"  "+jsonRes.canciones[m].name+' - '+jsonRes.canciones[m].artist;
                html+='</div><br>';

              }
              $('#ListaCanciones').append(html);
          }),"json";

          /*pob={
            "idFin":idFin,
            "graph":graphOrd
          }
          //console.log(graphOrd);
          $.post("http://95.216.205.0/music_path/get_Aestrella.php",JSON.stringify(pob),function(listaRes){
              console.log(listaRes);
          }),"json";*/

        }),"json";

}

function getRandomInt(min, max) {
  min = Math.ceil(min);
  max = Math.floor(max);
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

function getIndex(elemArray){
  var aux = 0;
  while(elemArray[aux].id!=idFin){
    aux++;
  }
  return aux;
}

function findNeedle(elemArray,needle){
  var aux = 0;
  while(elemArray[aux][0]!=needle){
    aux++;
  }
  return aux;
}

function quickSort(origArray){
  if (origArray.length == 0 || typeof origArray[0] == "string" ) { 
		return origArray;
	} else {
    var left = [];
    var right = [];
    var newArray = [];
    var pivot = origArray.pop();
    var length = origArray.length;
    for (var i = 0; i < length; i++) {
      if (parseFloat(origArray[i][1]) >= parseFloat(pivot[1])) {
        left.push(origArray[i]);
      } else {
        right.push(origArray[i]);
      }
      
    }
    return newArray.concat(quickSort(left), pivot, quickSort(right));
  }
}

