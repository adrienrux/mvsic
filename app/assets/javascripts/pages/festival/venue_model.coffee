class MvsicVenue

  constructor: (festival, attrs) ->
    @festival = festival
    @attrs =
      id: attrs.id
      name: attrs.name


window.MvsicVenue = MvsicVenue