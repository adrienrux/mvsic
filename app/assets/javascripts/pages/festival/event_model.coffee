class MvsicEvent


  @TEMPLATE = """
    <div class="event" data-event-id="{{ id }}">
      <div class="artist">{{ artist }}</div>
      <div class="startDate">{{ startTime }}</div>
    </div>
  """


  constructor: (festival, venue, attrs) ->
    @festival = festival
    @venue = venue
    @attrs =
      id: attrs.id
      date: attrs.date
      startTime: attrs.start_time
      artist: attrs.artist.name


  renderEvent: ->
    @festival.$el.find('.events').append(@_rawHtml())


  _rawHtml: ->
    _.template(MvsicEvent.TEMPLATE, @attrs)


window.MvsicEvent = MvsicEvent