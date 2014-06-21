class MvsicFestival

  constructor: (id) ->
    @attrs = id: id
    @venues = {}
    @events = {}
    @getAttributes()


  getAttributes: ->
    $.ajax
      url: "/api/festivals/#{@attrs.id}"
      success: (response) =>
        @loadFestival(response)


  loadFestival: (data) ->
    @attrs.name = data.name
    @attrs.location = data.location
    @attrs.description = data.description
    @attrs.startDate = data.start_date
    @attrs.endDate = data.end_date

    for venue in data.venues
      v = new MvsicVenue(@, venue)
      @venues[v.attrs.id] = v

      for evt in venue.events
        e = new MvsicEvent(@, v, evt)
        @events[e.attrs.id] = e


window.MvsicFestival = MvsicFestival