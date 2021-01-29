<?php
    function Normalisasi($val, $max, $min){
        $xy = (0.8 * ($val - $min) / ($max - $min)) + 0.1;
        return $xy;
    }

    function Denormalisasi($val, $max, $min){
        $xy = ((($val - 0.1) * ($max - $min)) + (0.8 * $min)) / 0.8;
        return $xy;
    }

    function sigmoid($t){
        $xy = 1 / (1 + exp(-$t));
        return $xy;
    }

    function bacaURL($url){		
		$session = curl_init(); // buat session		
		// setting CURL		
		curl_setopt($session, CURLOPT_URL, $url);
		curl_setopt($session, CURLOPT_RETURNTRANSFER, 1);
		$hasil = curl_exec($session);
		curl_close($session);
		return $hasil;
    }

?>