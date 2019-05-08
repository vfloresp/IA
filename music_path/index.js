var token;

$.get( "http://95.216.205.0/music_path/authentication.php", function(data) {
    token = data;
  });