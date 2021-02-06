<?php

	function fnDeleteItem($kon, $id, $nmTable){
		$index = 0;
		$SQLAdd =
			"DELETE FROM ".$nmTable." WHERE id = '".$id."'";

		if (mysqli_query($kon, $SQLAdd)) {
			$respon[$index]['result'] = "SUKSES";
			$respon[$index]['pesan'] = 'DATA BERHASIL DI HAPUS';
		} else {
			$respon[$index]['result'] = "null";
			$respon[$index]['pesan'] = 'MAAF, DATA GAGAL HAPUS';
		}
		
		return $respon;
	}

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
				$respon[$index]['imsak'] = substr($list['imsak'], 0, -3);    
				$respon[$index]['subuh'] = substr($list['subuh'], 0, -3);    
				$respon[$index]['terbit'] = substr($list['terbit'], 0, -3);    
				$respon[$index]['dzuhur'] = substr($list['dzuhur'], 0, -3);    
				$respon[$index]['ashr'] = substr($list['ashr'], 0, -3);    
				$respon[$index]['maghrib'] = substr($list['maghrib'], 0, -3);    
				$respon[$index]['isya'] = substr($list['isya'], 0, -3);   

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
	
    function fnGetKota($kon){
		$index = 0;
		$SQLAdd = 
			"SELECT * FROM tbl_kota WHERE stat = 'Y'";

		$query = mysqli_query($kon, $SQLAdd);

		if (mysqli_num_rows($query) > 0){
			while ($list = mysqli_fetch_array($query)) {
				$respon[$index]['nama'] = $list['nama'];     
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

	function fnDeleteFeed($kon, $id){
		$index = 0;
		$SQLAdd =
			"DELETE FROM tbl_feed WHERE id = '".$id."'";

		if (mysqli_query($kon, $SQLAdd)) {
			$respon[$index]['result'] = "SUKSES";
			$respon[$index]['pesan'] = 'DATA BERHASIL DI HAPUS';
		} else {
			$respon[$index]['result'] = "null";
			$respon[$index]['pesan'] = 'MAAF, DATA GAGAL HAPUS';
		}
		
		return $respon;
	}

	function fnUpdateFeed($kon, $id, $capt){
		$index = 0;

		$SQLAdd =
			"UPDATE tbl_feed SET
				caption = '".$capt."'
			WHERE id = '".$id."'";

		if (mysqli_query($kon, $SQLAdd)) {
			$respon[$index]['result'] = "SUKSES";
			$respon[$index]['pesan'] = 'DATA BERHASIL DI UBAH';
		} else {
			$respon[$index]['result'] = "null";
			$respon[$index]['pesan'] = 'MAAF, DATA GAGAL UBAH';
		}
		
		return $respon;
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

	function fnUpdateInformasi($kon, $id, $id_user, $caption, $isFeed){
		$index = 0;

		$SQLAdd =
			"UPDATE tbl_informasi SET
				id_user = '".$id_user."',
				caption = '".$caption."',
				isFeed = '".$isFeed."'
			WHERE id = '".$id."'";

		if (mysqli_query($kon, $SQLAdd)) {
			$respon[$index]['result'] = "SUKSES";
			$respon[$index]['pesan'] = 'DATA BERHASIL DI UBAH';
		} else {
			$respon[$index]['result'] = "null";
			$respon[$index]['pesan'] = 'MAAF, DATA GAGAL UBAH';
		}
		
		return $respon;
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

	function fnUpdateJamaah($kon, $id, $nm_jamaah, $alamat, $rt, $rw, $nohp, $email, $pendidikan, $pekerjaan, $jml_keluarga, $pengeluaran_rumah_tangga, $isImam){
		$SQLAdd =
			"UPDATE tbl_jamaah SET
				nm_jamaah = '".$nm_jamaah."',
				alamat = '".$alamat."',
				rt = '".$rt."',
				rw = '".$rw."',
				nohp = '".$nohp."',
				email = '".$email."',
				pendidikan = '".$pendidikan."',
				pekerjaan = '".$pekerjaan."',
				jml_keluarga = '".$jml_keluarga."',
				pengeluaran_rumah_tangga = '".$pengeluaran_rumah_tangga."',
				isImam = '".$isImam."'
			WHERE id = '".$id."'";

		if (mysqli_query($kon, $SQLAdd)) {
			return TRUE;
		} else {
			return FALSE;
		}
	}

	function fnDeleteJamaah($kon, $id){
		$SQLAdd =
			"DELETE FROM tbl_jamaah WHERE id = '".$id."'";

		if (mysqli_query($kon, $SQLAdd)) {
			return TRUE;
		} else {
			return FALSE;
		}
	}

	function fnInsertImamSholat($kon, $id_user, $id_imam, $id_imam_cadangan, $tgl, $tgl_sholat, $waktu_sholat){
		$index = 0;

		$SQLAdd = 
			"SELECT * FROM tbl_imam_sholat WHERE tgl_sholat = '".$tgl_sholat."' AND waktu_sholat = '".$waktu_sholat."'";
		$query = mysqli_query($kon, $SQLAdd);
		if (mysqli_num_rows($query) > 0){
			$respon[$index]['result'] = "null";
            $respon[$index]['pesan'] = 'DATA SUDAH ADA';
		} else {
			$SQLAdd =
				"INSERT INTO tbl_imam_sholat (id_user, id_imam, id_imam_cadangan, tgl, tgl_sholat, waktu_sholat) VALUES ('".$id_user."' ,'".$id_imam."' ,'".$id_imam_cadangan."' ,'".$tgl."' ,'".$tgl_sholat."' ,'".$waktu_sholat."')";

			if (mysqli_query($kon, $SQLAdd)) {
				$respon[$index]['result'] = "SUKSES";
                $respon[$index]['pesan'] = 'DATA BERHASIL DI INPUT';
			} else {
				$respon[$index]['result'] = "null";
                $respon[$index]['pesan'] = 'MAAF, DATA GAGAL INPUT';
			}
		}
		
		return $respon;
	}

	function fnUpdateImamSholat($kon, $id, $id_user, $id_imam, $id_imam_cadangan, $tgl, $tgl_sholat, $waktu_sholat){
		$index = 0;

		$SQLAdd = 
			"SELECT * FROM tbl_imam_sholat WHERE tgl_sholat = '".$tgl_sholat."' AND waktu_sholat = '".$waktu_sholat."' AND id NOT IN (".$id.")";
		$query = mysqli_query($kon, $SQLAdd);
		if (mysqli_num_rows($query) > 0){
			$respon[$index]['result'] = "null";
            $respon[$index]['pesan'] = 'DATA SUDAH ADA';
		} else {
			$SQLAdd =
				"UPDATE tbl_imam_sholat SET
					id_user = '".$id_user."',
					id_imam = '".$id_imam."',
					id_imam_cadangan = '".$id_imam_cadangan."',
					tgl = '".$tgl."',
					tgl_sholat = '".$tgl_sholat."',
					waktu_sholat = '".$waktu_sholat."'
				WHERE id = '".$id."'";

			if (mysqli_query($kon, $SQLAdd)) {
				$respon[$index]['result'] = "SUKSES";
                $respon[$index]['pesan'] = 'DATA BERHASIL DI UBAH';
			} else {
				$respon[$index]['result'] = "null";
                $respon[$index]['pesan'] = 'MAAF, DATA GAGAL UBAH';
			}
		}
		
		return $respon;
		
	}

	function fnDeleteImamSholat($kon, $id){
		$index = 0;
		$SQLAdd =
			"DELETE FROM tbl_imam_sholat WHERE id = '".$id."'";

		if (mysqli_query($kon, $SQLAdd)) {
			$respon[$index]['result'] = "SUKSES";
			$respon[$index]['pesan'] = 'DATA BERHASIL DI HAPUS';
		} else {
			$respon[$index]['result'] = "null";
			$respon[$index]['pesan'] = 'MAAF, DATA GAGAL HAPUS';
		}
		
		return $respon;
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

	function fnUpdateKajian($kon, $id, $id_user, $tema, $nm_ustadz, $tgl_pelaksanaan, $waktu_pelaksanaan, $capt, $isFeed){
		$index = 0;

		$SQLAdd =
			"UPDATE tbl_kajian SET
				id_user = '".$id_user."',
				tema = '".$tema."',
				nm_ustadz = '".$nm_ustadz."',
				tgl_pelaksanaan = '".$tgl_pelaksanaan."',
				waktu_pelaksanaan = '".$waktu_pelaksanaan."',
				caption = '".$capt."',
				isFeed = '".$isFeed."'
			WHERE id = '".$id."'";

		if (mysqli_query($kon, $SQLAdd)) {
			$respon[$index]['result'] = "SUKSES";
			$respon[$index]['pesan'] = 'DATA BERHASIL DI UBAH';
		} else {
			$respon[$index]['result'] = "null";
			$respon[$index]['pesan'] = 'MAAF, DATA GAGAL UBAH';
		}
		
		return $respon;
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
	
    function fnLoadJadwalImam($kon){
		$index = 0;
		
		$SQLAdd =
			"SELECT tis.id, tis.tgl_sholat, tis.waktu_sholat, ci.nm_jamaah as calon_imam, cci.nm_jamaah as calon_cadangan_imam, ci.id as id_ci, cci.id as id_cci 
			FROM tbl_imam_sholat tis
			LEFT JOIN tbl_jamaah ci ON ci.id = tis.id_imam
			LEFT JOIN tbl_jamaah cci ON cci.id = tis.id_imam_cadangan
			ORDER BY tis.tgl_sholat DESC LIMIT 100";

		$query = mysqli_query($kon, $SQLAdd);

		if (mysqli_num_rows($query) > 0){
			while ($list = mysqli_fetch_array($query)) {
				$respon[$index]['id'] = $list['id'];  
				$respon[$index]['tgl_sholat'] = $list['tgl_sholat'];  
				$respon[$index]['waktu_sholat'] = $list['waktu_sholat']; 
				$respon[$index]['calon_imam'] = $list['calon_imam'];  
				$respon[$index]['calon_cadangan_imam'] = $list['calon_cadangan_imam']; 
				$respon[$index]['id_ci'] = $list['id_ci']; 
				$respon[$index]['id_cci'] = $list['id_cci']; 

				$index++;
			}
		} else {
			$respon[$index]['result'] = 'null';	
			$respon[$index]['pesan'] = 'MAAF TIDAK ADA DATA DITEMUKAN';	
		}

		return $respon;
	}
	
    function fnLoadListImam($kon, $id){
		$index = 0;

		$SQLAdd = "";

		if ($id != '') {
			$SQLAdd = "AND id NOT IN (".$id.")";
		}
		
		$SQLAdd =
			"SELECT * FROM tbl_jamaah WHERE isImam = '1' ".$SQLAdd;

		$query = mysqli_query($kon, $SQLAdd);

		if (mysqli_num_rows($query) > 0){
			while ($list = mysqli_fetch_array($query)) { 
				$respon[$index]['id'] = $list['id'];
				$respon[$index]['nm_jamaah'] = $list['nm_jamaah']; 

				$index++;
			}
		} else {
			$respon[$index]['result'] = 'null';	
			$respon[$index]['pesan'] = 'MAAF TIDAK ADA DATA DITEMUKAN';	
		}

		return $respon;
	}
	
    function fnLoadFeed($kon, $isFeed){
		$index = 0;

		$SQLAdd = "";

		if ($isFeed != '') {
			$SQLAdd = "WHERE keterangan = 'FEED'";
		}
		
		$SQLAdd =
			"SELECT * FROM tbl_feed ".$SQLAdd." ORDER BY tgl DESC LIMIT 35";

		$query = mysqli_query($kon, $SQLAdd);

		if (mysqli_num_rows($query) > 0){
			while ($list = mysqli_fetch_array($query)) { 
				$respon[$index]['id'] = $list['id'];
				$respon[$index]['sub_id'] = $list['sub_id']; 
				$respon[$index]['tgl'] = substr($list['tgl'], 0, -3);
				$respon[$index]['caption'] = $list['caption']; 
				$respon[$index]['suka'] = $list['suka']; 
				$respon[$index]['nm_img'] = $list['nm_img']; 
				$respon[$index]['keterangan'] = $list['keterangan']; 

				$index++;
			}
		} else {
			$respon[$index]['result'] = 'null';	
			$respon[$index]['pesan'] = 'MAAF TIDAK ADA DATA DITEMUKAN';	
		}

		return $respon;
	}
	
    function fnLoadKajian($kon){
		$index = 0;
		
		$SQLAdd =
			"SELECT * FROM tbl_kajian ORDER BY tgl DESC LIMIT 20";

		$query = mysqli_query($kon, $SQLAdd);

		if (mysqli_num_rows($query) > 0){
			while ($list = mysqli_fetch_array($query)) { 
				$respon[$index]['id'] = $list['id'];
				$respon[$index]['tema'] = $list['tema']; 
				$respon[$index]['nm_ustadz'] = $list['nm_ustadz']; 
				$respon[$index]['tgl_pelaksanaan'] = $list['tgl_pelaksanaan']; 
				$respon[$index]['waktu_pelaksanaan'] = substr($list['waktu_pelaksanaan'], 0, -3); 
				$respon[$index]['caption'] = $list['caption']; 
				$respon[$index]['nm_img'] = $list['nm_img']; 
				$respon[$index]['isFeed'] = $list['isFeed']; 

				$index++;
			}
		} else {
			$respon[$index]['result'] = 'null';	
			$respon[$index]['pesan'] = 'MAAF TIDAK ADA DATA DITEMUKAN';	
		}

		return $respon;
	}
	
    function fnLoadInformasi($kon){
		$index = 0;
		
		$SQLAdd =
			"SELECT * FROM tbl_informasi ORDER BY tgl DESC LIMIT 20";

		$query = mysqli_query($kon, $SQLAdd);

		if (mysqli_num_rows($query) > 0){
			while ($list = mysqli_fetch_array($query)) { 
				$respon[$index]['id'] = $list['id'];
				$respon[$index]['tgl'] = substr($list['tgl'], 0, -3); 
				$respon[$index]['caption'] = $list['caption']; 
				$respon[$index]['isFeed'] = $list['isFeed']; 

				$index++;
			}
		} else {
			$respon[$index]['result'] = 'null';	
			$respon[$index]['pesan'] = 'MAAF TIDAK ADA DATA DITEMUKAN';	
		}

		return $respon;
	}
	
	?>