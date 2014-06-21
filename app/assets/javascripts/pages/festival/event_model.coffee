class MvsicEvent

  constructor: (festival, venue, attrs) ->
    @festival = festival
    @venue = venue
    @attrs =
      id: attrs.id
      date: attrs.date
      startTime: attrs.start_time
      artist: attrs.artist.name



window.MvsicEvent = MvsicEvent