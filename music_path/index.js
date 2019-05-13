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
          //console.log(JSON.parse(data));
          if(jsonData2.length-1==aux){
            var delayInMilliseconds = 100; //1 second

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
  //console.log(songs);
  songIds= new Array();
  //console.log(songs);
  for(var i = 0; i<songs.length;i++){
    for(var j = 0;j<songs[i].length;j++){
      songIds.push(songs[i][j]);
    }
  }
  //console.log(songIds);
  var param={
    "token":$(".token").text(),
    "ids":songIds
  }
  $.post("http://95.216.205.0/music_path/get_features.php",JSON.stringify(param),function(nodes){
          var grafo = new Array();
          jsonNodes = JSON.parse(nodes);
          var finPos = getIndex(jsonNodes.features);
          console.log(finPos);
          /*for(var i=0;i<jsonNodes.features.length;i+4){
            for(var j=0;j<4;i++){
              var hijos = new Array();
              for(var k=0;k<4;k++){
                if((i+4+k)<jsonNodes.features.length){
                  var danceability = Math.pow(jsonNodes.features[i+j].danceability-jsonNodes.features[i+4+k].danceability,2);
                  var energy = Math.pow(jsonNodes.features[i+j].energy-jsonNodes.features[i+4+k].energy,2);
                  var acousticness = Math.pow(jsonNodes.features[i+j].acousticness-jsonNodes.features[i+4+k].acousticness,2);
                  var instrumentalness = Math.pow(jsonNodes.features[i+j].instrumentalness-jsonNodes.features[i+4+k].instrumentalness,2);
                  var valence = Math.pow(jsonNodes.features[i+j].valence-jsonNodes.features[i+4+k].valence,2);
                  hijos.push([jsonNodes.features[i+4+k].id,Math.sqrt(danceability+energy+acousticness+instrumentalness+valence)])
                }
              }
              if((i+j)<jsonNodes.features.length){
                var danceabilityH = Math.pow(jsonNodes.features[i+j].danceability-jsonNodes.features[finPos].danceability,2);
                var energyH = Math.pow(jsonNodes.features[i+j].energy-jsonNodes.features[finPos].energy,2);
                var acousticnessH = Math.pow(jsonNodes.features[i+j].acousticness-jsonNodes.features[finPos].acousticness,2);
                var instrumentalnessH = Math.pow(jsonNodes.features[i+j].instrumentalness-jsonNodes.features[finPos].instrumentalness,2);
                var valenceH = Math.pow(jsonNodes.features[i+j].valence-jsonNodes.features[finPos].valence,2);
                valorH = Math.sqrt(danceabilityH+energyH+acousticnessH+instrumentalnessH+valenceH);
                grafo.push([jsonNodes.features[i+j].id,valorH,hijos]);
              }
            }
          }*/
          console.log(grafo);
        }),"json";

}

function getIndex(elemArray){
  var aux = 0;
  while(elemArray[aux].id!=idFin){
    aux++;
  }
  return aux;
}