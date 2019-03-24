<!DOCTYPE html>

<HEAD>
<TITLE>Calling SWI-Prolog from PHP (short)</TITLE>
</HEAD>

<H1>Calling SWI-Prolog from PHP (short)</H1>


<P>

<?php 
    $cmd = "swipl -f /var/www/html/test.pl -g 'test2(5,4,Y)',halt";
    exec( $cmd, $output );
    print_r( $output );
?> 

</P>