<!DOCTYPE html>

<HEAD>
<TITLE>Calling SWI-Prolog from PHP (short)</TITLE>
</HEAD>

<H1>Calling SWI-Prolog from PHP (short)</H1>


<P>

<?php 
    $cmd = "swipl -f /var/www/html/AlphaBeta.pl -g 'alphaBeta([[[4,4],A],[[5,0],B],[[0,6],C],[[5,5],D],[[0,2],E],[[6,4],F],[[4,3],G]],[[[5,6],I],[[3,6],J],[[2,6],K],[[1,6],L],[[4,5],M],[[3,5],N],[[2,5],O],[[1,5],P],[[2,4],Q],[[1,4],R],[[0,4],S],[[3,3],T],[[2,3],U],[[1,3],V],[[0,3],W],[[2,2],X],[[1,2],Y],[[1,1],Z],[[0,1],ZZ],[[0,0],YY]],[6,6],[],3,[[],-5000],[[],5000],1,ValorH,7),write(ValorH)',halt";
    exec( $cmd, $output );
    print_r( $output );
?> 

</P>