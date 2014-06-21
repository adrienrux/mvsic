class MvsicFestival


  @TEMPLATE = """
    <div class="name">{{ name }}</div>
    <div class="location">{{ location }}</div>
    <div class="startDate">{{ startDate }}</div>
    <div class="endDate">{{ endDate }}</div>
    <div class="description">{{ description }}</div>
    <div class="events"></div>
  """


  constructor: (id) ->
    @attrs = id: id
    @$el = $('#festival')
    @venues = {}
    @events = {}
    @getAttributes()


  getAttributes: ->
    $.ajax
      url: "/api/festivals/#{@attrs.id}"
      success: (response) =>
        @loadFestival(response)
        @renderFestival()
        @renderEvents()


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


  renderFestival: ->
    $('#festival').attr('data-festivalid', @attrs.id)
    $('#festival').append(@_rawHtml())


  renderEvents: ->
    for id, evt of @events
      evt.renderEvent()


  _rawHtml: ->
    _.template(MvsicFestival.TEMPLATE, @attrs)


window.MvsicFestival = MvsicFestival
