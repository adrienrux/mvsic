app.factory 'Festivals', ['$http', ($http) ->
  festivalList = []

  festivals =
    findId: (festivalSlug) ->
      return _(festivalList).findWhere({slug: festivalSlug}).id

    getFestivalList: ->
      festivalList

    listEmpty: ->
      _(festivalList).isEmpty()

    setFestivalList: (list) ->
      festivalList = list

  festivals
]
