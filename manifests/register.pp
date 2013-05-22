 define lsyncd::register ($directories, $order=10) {
   concat::fragment{"lsyncd_${title}":
      target  => lsyncd::conf_file,
      content => template('lsyncd/lsyncd_csync2_localsources.erb'),
   }
 } 