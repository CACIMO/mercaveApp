<?php 

    $dbhost = "localhost";
    $dbuser = "mercav5_edwin";
    $dbpass = "absoluto1";
    $db = "mercav5_produccion";
    
    $conn = new mysqli($dbhost, $dbuser, $dbpass, $db);
    
    $sql = "UPDATE ch_postmeta 
                SET meta_value = '4300' 
            WHERE ch_postmeta.meta_id = 208374
            AND ch_postmeta.meta_key= '_order_total'";

    $resultado = $conn->query($sql);
    $row = $resultado->fetch_assoc()
   
    print_r($row);
?>