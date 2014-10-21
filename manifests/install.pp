#
class powershell::install(
  $version = $powershell::version,
  $source_dir = $powershell::source_dir
) {

  $url = $powershell::params::version[$version][$::operatingsystemrelease][$::architecture]['url']
  $file = $powershell::params::version[$version][$::operatingsystemrelease][$::architecture]['file']
  $type = $powershell::params::version[$version][$::operatingsystemrelease][$::architecture]['type']

  # Taken from download_file - can't use directly as it work require a circular depdency between the modules

  file { "download-powershell.ps1":
    ensure  => present,
    path    => "C:\\Windows\\Temp\\download-powershell.ps1",
    content => template('powershell/download.ps1.erb')
  }

  exec { "download-${file}":
    command   => "${source_dir}\\download-powershell.ps1",
    provider  => powershell,
    onlyif    => "if(Test-Path -Path '${source_dir}\\${file}') { exit 1 } else { exit 0 }",
    logoutput => true,
    require   => File["download-powershell.ps1"]
  }

  if $type == 'exe' {
    exec { "install-powershell-${version}":
      command   => "& ${source_dir}\\${file} /q /norestart",
      provider  => powershell,
      logoutput => true,
      unless    => "if (\$host.version.Major -eq ${version}) { exit 0 } else { exit 1 }"
    }
  } else {

    exec { "install-powershell-${version}":
      command   => "& C:\\Windows\\System32\\wusa.exe ${source_dir}\\${file} /quiet /norestart",
      provider  => powershell,
      logoutput => true,
      unless    => "if (\$host.version.Major -eq ${version}) { exit 0 } else { exit 1 }"
    }
  }
}
