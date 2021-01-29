<?php
    set_time_limit(0);
    
    include_once 'function.php';

    $koneksi = @mysqli_connect("localhost", "root", "");
    $database = mysqli_select_db($koneksi, "db_masjid");
    
    function fnUpdateStatusReg($con, $idReg, $st){
		$xx = 
			"UPDATE tbl_kota SET stat = '".$st."' WHERE id = '".$idReg."'";

		try {
			mysqli_autocommit($con, FALSE); 
			mysqli_query($con, $xx);
			mysqli_commit($con);
		} catch (Exception $e) {
			mysqli_rollback($con);
		}
    }

    $plus = '+0 hours';

    $tg = date(' l, d M Y H:i:s');

    $tgl = date('Y-m-d', strtotime($plus,strtotime($tg)));

    $stahun = date('Y', strtotime($plus,strtotime($tg)));
    $sbulan = date('m', strtotime($plus,strtotime($tg)));
    $stgl = date('d', strtotime($plus,strtotime($tg)));

    $respon = array();
    $index = 0;

    $query = mysqli_query($koneksi,"SELECT * FROM tbl_kota WHERE stat = 'Y'");
	while ($list = mysqli_fetch_array($query)) {
        $url = "https://api.pray.zone/v2/times/this_month.json?city=".$list["nama"];
        $sumber =  bacaURL($url);
        $arrdata = json_decode($sumber,true);
    
        $respon[$index]["id"] = $list["id"];
        $respon[$index]["kota"] = $list["nama"]; 

        if ($arrdata == '') {
            fnUpdateStatusReg($koneksi, $list["id"], "N");
            $respon[$index]["status"] = "gagal"; 
        } else {
            $respon[$index]["status"] = "sukses"; 

            $SQLAdd =
                "DELETE FROM tbl_jadwalsholat WHERE id_kota = '".$list['id']."' AND YEAR(tgl) = ".$stahun." AND MONTH(tgl) = ".$sbulan;
            mysqli_query($koneksi, $SQLAdd);

            $SQLAdd = "INSERT INTO tbl_jadwalsholat (id_kota, tgl, imsak, subuh, terbit, dzuhur, ashr, maghrib, isya) VALUES ";
            for ($i = 0 ; $i < count($arrdata['results']['datetime']); $i++){
                if ($i == 0) {
                    $tSQL = "(
                        '".$list['id']."',
                        '".$arrdata['results']['datetime'][$i]['date']['gregorian']."',
                        '".$arrdata['results']['datetime'][$i]['times']['Imsak']."',
                        '".$arrdata['results']['datetime'][$i]['times']['Fajr']."',
                        '".$arrdata['results']['datetime'][$i]['times']['Sunrise']."',
                        '".$arrdata['results']['datetime'][$i]['times']['Dhuhr']."',
                        '".$arrdata['results']['datetime'][$i]['times']['Asr']."',
                        '".$arrdata['results']['datetime'][$i]['times']['Maghrib']."',
                        '".$arrdata['results']['datetime'][$i]['times']['Isha']."'
                    )";
                } else {
                    $tSQL = $tSQL.",(
                        '".$list['id']."',
                        '".$arrdata['results']['datetime'][$i]['date']['gregorian']."',
                        '".$arrdata['results']['datetime'][$i]['times']['Imsak']."',
                        '".$arrdata['results']['datetime'][$i]['times']['Fajr']."',
                        '".$arrdata['results']['datetime'][$i]['times']['Sunrise']."',
                        '".$arrdata['results']['datetime'][$i]['times']['Dhuhr']."',
                        '".$arrdata['results']['datetime'][$i]['times']['Asr']."',
                        '".$arrdata['results']['datetime'][$i]['times']['Maghrib']."',
                        '".$arrdata['results']['datetime'][$i]['times']['Isha']."'
                    )";
                }
            }

            #$respon[$index]["SQL"] = $SQLAdd.$tSQL; 

            mysqli_query($koneksi, $SQLAdd.$tSQL);
        }

        $index++;
    }

    echo json_encode($respon,JSON_PRETTY_PRINT);
    

?>