 define lsyncd::register ($directories, $directory_root, $order=10) {
   concat::fragment{"lsyncd_${title}":
      target  => $lsyncd::conf_file,
      content => template('lsyncd/lsyncd_csync2_localsources.erb'),
   }
 } 