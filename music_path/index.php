<!DOCTYPE HTML>
<html>

<head>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
    <link rel="stylesheet" href="style.css">
    <TITLE>Music Path</TITLE>
</head>

<body>
    <h1>Music Path</h1>
    <h2>Encuentra la transición perfecta entre cualquier par de canciones,
       solo selecciona tu canción de inicio, canción de fin y listo.</h2>
    <!-- <div id="searchBar"></div> -->
    <div class="row justify-content-center">
        <div class="col-md-6">
            <input type="text" class="form-control" placeholder="id de inicio" aria-label="Recipient's username" id="idIni"/>
        </div>
    </div>
    <br></br>
    <div class="row justify-content-center">
        <div class="col-md-6">
            <input type="text" class="form-control" placeholder="id de fin" aria-label="Recipient's username" id="idFin"/>
        </div>
    </div>
    <br></br>
    <div class="row justify-content-center">
        <div class="col-md-6 justify-content-center" style="text-align: center">
            <button type="button" class="btn btn-primary" id="button_busqueda" style="background-color:#314455">Buscar</button>
        </div>
    </div>
    <div class="row justify-content-center">
        <div class="col-md-6 justify-content-center" id="ListaCanciones" style="text-align: center">
            
        </div>
    </div>
    
        


    <!-- Load React. -->
    <!-- Note: when deploying, replace "development.js" with "production.min.js". -->
    <script src="https://unpkg.com/react@16/umd/react.development.js" crossorigin></script>
    <script src="https://unpkg.com/react-dom@16/umd/react-dom.development.js" crossorigin></script>
    <!-- Load our React component. -->
    <!-- <script type="text/babel" src="src/search_bar.js"></script> -->
    <!-- <script type="text/babel" src="src/selected_song.js"></script> -->
    <script src="http://code.jquery.com/jquery-3.3.1.min.js" integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8=" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
    <script src="index.js"></script>
    <script src="https://unpkg.com/babel-standalone@6/babel.min.js"></script>
    <meta charset="utf-8">
    <?php
        // abrimos la sesión cURL
        $ch = curl_init();
    
        // definimos la URL a la que hacemos la petición
        curl_setopt($ch, CURLOPT_URL,"https://accounts.spotify.com/api/token");
        // indicamos el tipo de petición: POST
        curl_setopt($ch, CURLOPT_POST, TRUE);
        // definimos cada uno de los parámetros
        curl_setopt($ch, CURLOPT_POSTFIELDS, "grant_type=client_credentials");

        // definimos los headers
        curl_setopt($ch, CURLOPT_HTTPHEADER, array('Authorization: Basic MDM3YzM2YTVkNzEwNDQ5NWJkNmI3YzQzMGEyY2NmM2M6YjQxMzUxMTA2YWRiNGFlZTk1ZDRjNDdlNGMwNjZlY2Y='  
        ));

        // recibimos la respuesta y la guardamos en una variable
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        $remote_server_output = curl_exec($ch);

        // cerramos la sesión cURL
        curl_close($ch);

        $json_response = json_decode($remote_server_output);
        $token = $json_response->access_token;
    
        // regresamos los datos 
        echo '<div class="token" style="visibility: hidden;">'.$token.'</div>';
    ?>
</body>


</html>