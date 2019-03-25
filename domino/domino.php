<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
    <meta charset="utf-8">
    <TITLE>Domino IA</TITLE>
</head>



<body>
    <div class="row">
        <div class="col-md-12 ">
            <div class="row">
                <div class="col-md-12" >
                    <br>
                    <H1 style="text-align:center;">Las CSP y Víctor</H1>
                </div>
            </div>
            <br>
            <div class="row justify-content-center">
                <br>
                <div class=" col-md-9" >
                    <H2>Mis Piezas:</H2>
                </div>
            </div>
            <div class="row justify-content-center">
                <div class="col-md-9" >
                    <ul class="contPiezas"></ul>
                </div>
            </div>
            <br>
            <div class="row justify-content-center">
                <div class="col-md-10" >
                    <div class="row">
                        <div class="col-md-6" >
                            <H2 style="text-align:center;">Mi Tiro:</H2>
                            <div class="row" style="text-align:center;">
                                <div class="col-md-12" >
                                    <H3 class="miTiro"></H3>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6" style="text-align:center;">
                            <button type="button" class="btn btn-success" disabled>Mi turno</button><br><br>
                            <button type="button" class="btn btn-danger" disabled>Contrincante</button><br><br>
                            <button type="button" class="btn btn-dark">Nuevo Juego</button><br><br>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="http://code.jquery.com/jquery-3.3.1.min.js" integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8=" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
    <script src="./node_modules/sweetalert2/dist/sweetalert2.all.min.js"></script>
    <script src="domino.js"></script>
</body>
</html>


<style>

body { 
  background: url("tablero.jpg") no-repeat center center fixed; 
  -webkit-background-size: cover;
  -moz-background-size: cover;
  -o-background-size: cover;
  background-size: cover;
}
</style>
