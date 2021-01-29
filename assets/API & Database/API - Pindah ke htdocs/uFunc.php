<?php
    function fnGetJadwalByTanggal($kon, $kota, $tgl){
		$index = 0;
		
		$SQLAdd = 
			"SELECT * FROM tbl_jadwalsholat js
			LEFT JOIN tbl_kota kt ON kt.id = js.id_kota
			WHERE js.tgl = '".$tgl."' AND kt.nama = '".$kota."'";

		$query = mysqli_query($kon, $SQLAdd);

		if (mysqli_num_rows($query) > 0){
			while ($list = mysqli_fetch_array($query)) {
				$respon[$index]['tgl'] = $list['tgl'];    
				$respon[$index]['imsak'] = $list['imsak'];    
				$respon[$index]['subuh'] = $list['subuh'];    
				$respon[$index]['terbit'] = $list['terbit'];    
				$respon[$index]['dzuhur'] = $list['dzuhur'];    
				$respon[$index]['ashr'] = $list['ashr'];    
				$respon[$index]['maghrib'] = $list['maghrib'];    
				$respon[$index]['isya'] = $list['isya'];   

				$index++;
			}
		} else {
			$respon[$index]['result'] = 'null';	
			$respon[$index]['pesan'] = 'MAAF DATA BELUM ADA';	
		}

		return $respon;
	}
	
    function fnGetJadwalThisMonth($kon, $kota){
		$index = 0;
		$plus = '+0 hours';
		$tg = date(' l, d M Y H:i:s');
		$tgl = date('Y-m-d', strtotime($plus,strtotime($tg)));

		$stahun = date('Y', strtotime($plus,strtotime($tg)));
		$sbulan = date('m', strtotime($plus,strtotime($tg)));
		$stgl = date('d', strtotime($plus,strtotime($tg)));
		
		$SQLAdd = 
			"SELECT * FROM tbl_jadwalsholat js
			LEFT JOIN tbl_kota kt ON kt.id = js.id_kota
			WHERE YEAR(js.tgl) = ".$stahun." AND MONTH(js.tgl) = ".$sbulan." AND kt.nama = '".$kota."'";

		$query = mysqli_query($kon, $SQLAdd);

		if (mysqli_num_rows($query) > 0){
			while ($list = mysqli_fetch_array($query)) {
				$respon[$index]['tgl'] = $list['tgl'];    
				$respon[$index]['imsak'] = $list['imsak'];    
				$respon[$index]['subuh'] = $list['subuh'];    
				$respon[$index]['terbit'] = $list['terbit'];    
				$respon[$index]['dzuhur'] = $list['dzuhur'];    
				$respon[$index]['ashr'] = $list['ashr'];    
				$respon[$index]['maghrib'] = $list['maghrib'];    
				$respon[$index]['isya'] = $list['isya'];   

				$index++;
			}
		} else {
			$respon[$index]['result'] = 'null';	
			$respon[$index]['pesan'] = 'MAAF DATA BELUM ADA';	
		}

		return $respon;
	}

	function fnInsertFeed($kon, $id_user, $tgl, $caption, $nm_img, $keterangan, $sub_id){
		$SQLAdd =
			"INSERT INTO tbl_feed (id_user, tgl, caption, nm_img, keterangan, sub_id) VALUES ('".$id_user."', '".$tgl."', '".$caption."', '".$nm_img."', '".$keterangan."', '".$sub_id."')";

		if (mysqli_query($kon, $SQLAdd)) {
			return TRUE;
		} else {
			return FALSE;
		}
	}

	function fninsertInformasi($kon, $id_user, $tgl, $caption, $isFeed){
		$SQLAdd =
			"INSERT INTO tbl_informasi (id_user, tgl, caption, isFeed) VALUES ('".$id_user."', '".$tgl."', '".$caption."', '".$isFeed."')";

		if (mysqli_query($kon, $SQLAdd)) {
			return TRUE;
		} else {
			return FALSE;
		}
	}

	function fnInsertJamaah($kon, $nm_jamaah, $alamat, $rt, $rw, $nohp, $email, $pendidikan, $pekerjaan, $jml_keluarga, $pengeluaran_rumah_tangga, $isImam){
		$SQLAdd =
			"INSERT INTO tbl_jamaah (nm_jamaah, alamat, rt, rw, nohp, email, pendidikan, pekerjaan, jml_keluarga, pengeluaran_rumah_tangga, isImam) VALUES 
			('".$nm_jamaah."' ,'".$alamat."' ,'".$rt."' ,'".$rw."' ,'".$nohp."' ,'".$email."', '".$pendidikan."', '".$pekerjaan."', '".$jml_keluarga."', '".$pengeluaran_rumah_tangga."', '".$isImam."')";

		if (mysqli_query($kon, $SQLAdd)) {
			return TRUE;
		} else {
			return FALSE;
		}
	}

	function fnUpdateJamaah($kon, $nm_jamaah, $alamat, $rt, $rw, $nohp, $email, $pendidikan, $pekerjaan, $jml_keluarga, $pengeluaran_rumah_tangga, $isImam){
		$SQLAdd =
			"INSERT INTO tbl_jamaah (nm_jamaah, alamat, rt, rw, nohp, email, pendidikan, pekerjaan, jml_keluarga, pengeluaran_rumah_tangga, isImam) VALUES 
			('".$nm_jamaah."' ,'".$alamat."' ,'".$rt."' ,'".$rw."' ,'".$nohp."' ,'".$email."', '".$pendidikan."', '".$pekerjaan."', '".$jml_keluarga."', '".$pengeluaran_rumah_tangga."', '".$isImam."')";

		if (mysqli_query($kon, $SQLAdd)) {
			return TRUE;
		} else {
			return FALSE;
		}
	}

	function fnInsertImamSholat($kon, $id_user, $id_imam, $id_imam_cadangan, $tgl, $tgl_sholat, $waktu_sholat){
		$SQLAdd =
			"INSERT INTO tbl_imam_sholat (id_user, id_imam, id_imam_cadangan, tgl, tgl_sholat, waktu_sholat) VALUES ('".$id_user."' ,'".$id_imam."' ,'".$id_imam_cadangan."' ,'".$tgl."' ,'".$tgl_sholat."' ,'".$waktu_sholat."')";

		if (mysqli_query($kon, $SQLAdd)) {
			return TRUE;
		} else {
			return FALSE;
		}
	}

	function fnInsertKajian($kon, $id_user, $tgl, $tema, $nm_ustadz, $tgl_pelaksanaan, $waktu_pelaksanaan, $caption, $nm_img, $isFeed){
		$SQLAdd =
			"INSERT INTO tbl_kajian (id_user, tgl, tema, nm_ustadz, tgl_pelaksanaan, waktu_pelaksanaan, caption, nm_img, isFeed) 
			VALUES ('".$id_user."','".$tgl."','".$tema."','".$nm_ustadz."','".$tgl_pelaksanaan."','".$waktu_pelaksanaan."','".$caption."','".$nm_img."','".$isFeed."')";
		if (mysqli_query($kon, $SQLAdd)) {
			return TRUE;
		} else {
			return FALSE;
		}
	}
	
    function fnLoadPermission($kon, $id_user){
		$index = 0;
		
		$SQLAdd =
			"SELECT * FROM permission WHERE id_user = ".$id_user." ORDER BY urut ASC";

		$query = mysqli_query($kon, $SQLAdd);

		if (mysqli_num_rows($query) > 0){
			while ($list = mysqli_fetch_array($query)) {
				$respon[$index]['user'] = $list['id_user'];  
				$respon[$index]['menu'] = $list['menu'];  
				$respon[$index]['akses'] = $list['akses'];   

				$index++;
			}
		} else {
			$respon[$index]['result'] = 'null';	
			$respon[$index]['pesan'] = 'MAAF ANDA TIDAK MEMPUNYAI HAK AKSES APAPUN';	
		}

		return $respon;
	}
	
    function fnLoadJamaah($kon){
		$index = 0;
		
		$SQLAdd =
			"SELECT * FROM tbl_jamaah ORDER BY nm_jamaah ASC";

		$query = mysqli_query($kon, $SQLAdd);

		if (mysqli_num_rows($query) > 0){
			while ($list = mysqli_fetch_array($query)) {
				$respon[$index]['nm_jamaah'] = $list['nm_jamaah'];  
				$respon[$index]['alamat'] = $list['alamat'];  
				$respon[$index]['rt'] = $list['rt']; 
				$respon[$index]['rw'] = $list['rw'];  
				$respon[$index]['nohp'] = $list['nohp'];  
				$respon[$index]['email'] = $list['email']; 
				$respon[$index]['pendidikan'] = $list['pendidikan'];  
				$respon[$index]['pekerjaan'] = $list['pekerjaan'];  
				$respon[$index]['jml_keluarga'] = $list['jml_keluarga'];   
				$respon[$index]['pengeluaran_rumah_tangga'] = $list['pengeluaran_rumah_tangga'];  
				$respon[$index]['isImam'] = $list['isImam'];   
				$respon[$index]['id'] = $list['id'];   

				$index++;
			}
		} else {
			$respon[$index]['result'] = 'null';	
			$respon[$index]['pesan'] = 'MAAF TIDAK ADA DATA DITEMUKAN';	
		}

		return $respon;
	}
	
	?>