app.factory 'Time', () ->
  formatAMPM = (date) ->
    UTCDate = date.toUTCString()
    hours = UTCDate.substr(17, 2)
    ampm = if (hours >= 12) then 'pm' else 'am'
    time = format12Hour(date)
    strTime = "#{time}#{ampm}"

  format12Hour = (date) ->
    UTCDate = date.toUTCString()
    hours = UTCDate.substr(17, 2)
    minutes = UTCDate.substr(20, 2)
    hours = hours % 12
    hours = if hours then hours else 12
    strTime = "#{hours}:#{minutes}"

  formatFullDate = (dat) ->


  {
    format12Hour: format12Hour
    formatAMPM: formatAMPM
  }
