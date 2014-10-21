class powershell(
  $version,
  $source_dir = $powershell::params::source_dir
) inherits powershell::params {

  case $version {
    '1': {
      case $::operatingsystemversion {
        /^Windows.Server.(2003).?(R2)?.*/: { include powershell::install }
        default: { debug("powershell version: ${version} is not needed on this version of windows") }
      }
    }
    '2': {
      case $::operatingsystemversion {
        /^Windows.Server.(2003|2008).*/: { include powershell::install }
        default: { debug("powershell version: ${version} is not needed on this version of windows") }
      }
    }
    '3': {
      case $::operatingsystemversion {
        /^Windows.Server.(2008).?(R2)?.*/: { include powershell::install }
        default: { debug("powershell version: ${version} is not needed on this version of windows") }
      }
    }
    '4': {
      case $::operatingsystemversion {
        /^^Windows.Server.(2008 R2|2012).*/: { include powershell::install }
        default: { debug("powershell version: ${version} is not needed on this version of windows") }
      }
    }
    default: {
      err("powershell ${version} is not supported on this version of windows")
    }
  }

}
