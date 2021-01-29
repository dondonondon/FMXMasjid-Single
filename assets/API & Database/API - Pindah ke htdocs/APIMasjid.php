<?php
    #include_once '../function.php';
    include_once 'uFunc.php';

    $koneksi = @mysqli_connect("localhost", "root", "");
    $database = mysqli_select_db($koneksi, "db_masjid");

    $plus = '+7 hours';
	$tg = date(' l, d M Y H:i:s');
	$tgl = date('Y-m-d H:i:s', strtotime($plus,strtotime($tg)));

    $stahun = date('Y', strtotime($plus,strtotime($tg)));
    $sbulan = date('m', strtotime($plus,strtotime($tg)));
    $stgl = date('d', strtotime($plus,strtotime($tg)));

    $longtgl = date('Y-m-d H:i:s', strtotime($plus,strtotime($tg)));
    $shorttgl = date('Y-m-d', strtotime($plus,strtotime($tg)));
    $jam = date('H:i:s', strtotime($plus,strtotime($tg))); 
    
    $aURL = "http://localhost/appru/API/Masjid/APIMasjid.php?key=apiapi&act=";
    
    $folder = 'files/';

	$respon = array(); 
	$keyAkses = 'apiapi';
	
	$key = $_GET['key'];
	$act = $_GET['act'];
	
	if ($key == $keyAkses){
		$index = 0;
		if (!$koneksi) {
			$respon[$index]['result'] = 'null';
			$respon[$index]['pesan'] = 'MAAF, TIDAK ADA DATA';	
		} else {
			if ($act=='getByTgl'){ 
                //http://localhost/appru/API/Masjid/APIMasjid.php?key=apiapi&act=getByTgl&kota=sleman&date=2021-01-20
                $kota = strtoupper($_GET['kota']);
                $date = $_GET['date'];

				$SQLAdd = 
                    "SELECT * FROM tbl_jadwalsholat js
                    LEFT JOIN tbl_kota kt ON kt.id = js.id_kota
                    WHERE js.tgl = '".$date."' AND kt.nama = '".$kota."'";

                $query = mysqli_query($koneksi, $SQLAdd);

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
			} elseif ($act=='getToday') {
                //http://localhost/appru/API/Masjid/APIMasjid.php?key=apiapi&act=getToday&kota=sleman
                $kota = strtoupper($_GET['kota']);
                #$sumber = bacaURL($aURL."getByTgl&kota=".$kota."&date=".$tgl);
                #$respon = json_decode($sumber,true);
                $respon = fnGetJadwalByTanggal($koneksi, $kota, $tgl);
			} elseif ($act=='getTomorrow') {
                //http://localhost/appru/API/Masjid/APIMasjid.php?key=apiapi&act=getTomorrow&kota=sleman
                $kota = strtoupper($_GET['kota']);
                $tgl = date('Y-m-d', strtotime('+1 days',strtotime($tgl)));
                $respon = fnGetJadwalByTanggal($koneksi, $kota, $tgl);
            } elseif ($act=='getYesterday') {
                //http://localhost/appru/API/Masjid/APIMasjid.php?key=apiapi&act=getYesterday&kota=sleman
                $kota = strtoupper($_GET['kota']);
                $tgl = date('Y-m-d', strtotime('-1 days',strtotime($tgl)));
                $respon = fnGetJadwalByTanggal($koneksi, $kota, $tgl);
            } elseif ($act=='getThisMonth') {
                //http://localhost/appru/API/Masjid/APIMasjid.php?key=apiapi&act=getThisMonth&kota=sleman
                $kota = strtoupper($_GET['kota']);
				$respon = fnGetJadwalThisMonth($koneksi, $kota);
            } elseif ($act=='putFileV2') {
				$target_file = $folder . basename($_FILES["fileToUpload"]["name"]);
				$nmFile = $_POST['nmFile'];

				if(file_exists($folder.$nmFile)) {
					unlink( $folder.$nmFile);
				}

				if (move_uploaded_file($_FILES["fileToUpload"]["tmp_name"], $folder.$nmFile)) {
					$respon[$index]['result'] = "SUKSES";
					$respon[$index]['pesan'] = "BERHASIL UPLOAD";
				} else {
					$respon[$index]['result'] = "null";
					$respon[$index]['pesan'] = 'MAAF, GAGAL UPLOAD';
				}
			} elseif ($act=='insertFeed') {
                //http://localhost/appru/API/Masjid/APIMasjid.php?key=apiapi&act=insertFeed

                $target_file = $folder . basename($_FILES["fileToUpload"]["name"]);
				$nmFile = $_POST['nmFile'];

                $id_user = $_POST['id_user'];
                $caption = $_POST['caption'];

                if(file_exists($folder.$nmFile)) {
					unlink( $folder.$nmFile);
                }
                
                if (move_uploaded_file($_FILES["fileToUpload"]["tmp_name"], $folder.$nmFile)) {
                    if (fnInsertFeed($koneksi, $id_user, $tgl, $caption, $nmFile, 'FEED', '')) {
                        $respon[$index]['result'] = "SUKSES";
					    $respon[$index]['pesan'] = 'DATA BERHASIL DI INPUT';
                    } else {
                        $respon[$index]['result'] = "null";
					    $respon[$index]['pesan'] = 'MAAF, DATA GAGAL INPUT';
                    }
                } else {
                    $respon[$index]['result'] = "null";
					$respon[$index]['pesan'] = 'MAAF, GAGAL UPLOAD FOTO';
                }
            } elseif ($act=='insertInformasi') {
                //http://localhost/appru/API/Masjid/APIMasjid.php?key=apiapi&act=insertInformasi
                $id_user = $_POST['id_user'];
                $caption = $_POST['caption'];
                $isFeed = $_POST['isFeed'];

                if (fninsertInformasi($koneksi, $id_user, $tgl, $caption, $isFeed)) {
                    $respon[$index]['result'] = "SUKSES";
                    $respon[$index]['pesan'] = 'DATA BERHASIL DI INPUT';
                } else {
                    $respon[$index]['result'] = "null";
                    $respon[$index]['pesan'] = 'MAAF, DATA GAGAL INPUT';
                }
            } elseif ($act=='insertJamaah') {
                //http://localhost/appru/API/Masjid/APIMasjid.php?key=apiapi&act=insertInformasi
                $nm_jamaah = $_POST['nm_jamaah'];
                $alamat = $_POST['alamat'];
                $rt = $_POST['rt'];
                $rw = $_POST['rw'];
                $nohp = $_POST['nohp'];
                $email = $_POST['email'];
                $pendidikan = $_POST['pendidikan'];
                $pekerjaan = $_POST['pekerjaan'];
                $jml_keluarga = $_POST['jml_keluarga'];
                $pengeluaran_rumah_tangga = $_POST['pengeluaran_rumah_tangga'];
                $isImam = $_POST['isImam'];

                if (fnInsertJamaah($koneksi, $nm_jamaah, $alamat, $rt, $rw, $nohp, $email, $pendidikan, $pekerjaan, $jml_keluarga, $pengeluaran_rumah_tangga, $isImam)) {
                    $respon[$index]['result'] = "SUKSES";
                    $respon[$index]['pesan'] = 'DATA BERHASIL DI INPUT';
                } else {
                    $respon[$index]['result'] = "null";
                    $respon[$index]['pesan'] = 'MAAF, DATA GAGAL INPUT';
                }
            } elseif ($act=='insertImamSholat') {
                //http://localhost/appru/API/Masjid/APIMasjid.php?key=apiapi&act=insertInformasi
                $id_user = $_POST['id_user'];
                $id_imam = $_POST['id_imam'];
                $id_imam_cadangan = $_POST['id_imam_cadangan'];
                $waktu_sholat = $_POST['waktu_sholat'];

                if (fnInsertImamSholat($koneksi, $id_user, $id_imam, $id_imam_cadangan, $tgl, $shorttgl, $waktu_sholat)) {
                    $respon[$index]['result'] = "SUKSES";
                    $respon[$index]['pesan'] = 'DATA BERHASIL DI INPUT';
                } else {
                    $respon[$index]['result'] = "null";
                    $respon[$index]['pesan'] = 'MAAF, DATA GAGAL INPUT';
                }
            } elseif ($act=='insertKajian') {
                //http://localhost/appru/API/Masjid/APIMasjid.php?key=apiapi&act=insertInformasi
                $target_file = $folder . basename($_FILES["fileToUpload"]["name"]);
                $nmFile = $_POST['nmFile'];
                
                $id_user = $_POST['id_user'];
                $tema = $_POST['tema'];
                $nm_ustadz = $_POST['nm_ustadz'];
                $tgl_pelaksanaan = $_POST['tgl_pelaksanaan'];
                $waktu_pelaksanaan = $_POST['waktu_pelaksanaan'];
                $caption = $_POST['caption'];
                $isFeed = $_POST['isFeed'];

                if(file_exists($folder.$nmFile)) {
					unlink( $folder.$nmFile);
                }

                if (move_uploaded_file($_FILES["fileToUpload"]["tmp_name"], $folder.$nmFile)) {
                    if (fnInsertKajian($koneksi, $id_user, $tgl, $tema, $nm_ustadz, $tgl_pelaksanaan, $waktu_pelaksanaan, $caption, $nmFile, $isFeed)) {
                        $respon[$index]['result'] = "SUKSES";
					    $respon[$index]['pesan'] = 'DATA BERHASIL DI INPUT';
                    } else {
                        $respon[$index]['result'] = "null";
					    $respon[$index]['pesan'] = 'MAAF, DATA GAGAL INPUT';
                    }
                } else {
                    $respon[$index]['result'] = "null";
					$respon[$index]['pesan'] = 'MAAF, GAGAL UPLOAD FOTO';
                }
            } elseif ($act=='loadPermission') {
                //http://localhost/appru/API/Masjid/APIMasjid.php?key=apiapi&act=loadPermission
				$id = $_POST['id'];
				$respon = fnLoadPermission($koneksi, $id);
			} elseif ($act=='loadJamaah') {
                //http://localhost/appru/API/Masjid/APIMasjid.php?key=apiapi&act=loadJamaah
				$respon = fnLoadJamaah($koneksi);
			} else {
				$respon[$index]['result'] = "null";
                $respon[$index]['pesan'] = 'MAAF, TIDAK ADA DATA';
			}
		}
	} else {
		$respon[$index]['result'] = 'null';
        $respon[$index]['pesan'] = 'MAAF, TIDAK ADA DATA';
	}
	echo json_encode($respon,JSON_PRETTY_PRINT);
	?>