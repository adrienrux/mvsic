app.directive 'timetable', ['Time', (Time) ->
  MARGIN = {top: 0, right: 20, bottom: 50, left: 20}
  ROW_HEIGHT = 40
  MILLISECONDS_PER_BLOCK = 900000 # 15 Minutes
  BOX_H_MARGIN = 1
  BOX_V_MARGIN = 1
  EVENT_BOX_WIDTH = 200

  timetable =
    restrict: 'A'
    scope:
      festival: '='
      day: '='
      venues: '='

    link: (scope, element, attrs) ->
      scope.$watch 'festival', ->
        if scope.festival
          scope.events = scope.festival.events

      scope.$watch 'day', ->
        if scope.events && scope.venues.length
          setupTimetable()

      scope.$watch 'venues', ->
        if scope.events && scope.day
          shiftTimeTable()

      scope.$on 'deselectEvent', (event, data) ->
        deselectedEvent = _(scope.events).findWhere({id: data.id})
        deselectedEvent.selected = false
        d3.select("div.event-wrapper#event-#{data.id}").attr('class', 'event-wrapper')

      yScale = d3.time.scale()
      xScale = d3.scale.ordinal()

      setupTimetable = ->
        scope.filteredDaysEvents = filterEventsByDay(scope.events, scope.day)
        scope.filteredVenueNames = scope.venues
        scope.filteredEvents = filterEventsByVenue(scope.filteredDaysEvents, scope.venues)

        minTime = _(scope.filteredDaysEvents).chain().pluck('start_time').map((t) -> Date.parse(t)).min().value()
        minDate = new Date(minTime)        
        minTime = minDate.setMinutes(Math.floor(minDate.getMinutes() / 15) * 15)

        maxTime = _(scope.filteredDaysEvents).chain().pluck('end_time').map((t) -> Date.parse(t)).max().value()
        maxDate = new Date(maxTime)
        maxTime = maxDate.setMinutes(Math.ceil(maxDate.getMinutes() / 15) * 15)

        timeslots = calculateTimeslots(minTime, maxTime)
        height = (timeslots.length * ROW_HEIGHT)
        scope.width = (200 + MARGIN.left + MARGIN.right) * scope.filteredVenueNames.length

        # Adjust the scales / axis
        yScale.range([0, height]).domain([minTime, maxTime])
        xScale.domain(scope.filteredVenueNames).rangeBands([60, scope.width], 0, 0)

        d3.select(element[0]).select('div.timetable')
          .transition().duration(250).style('opacity', 0).remove()

        base = d3.select(element[0]).append('div')
          .attr('class', 'timetable')
          .style('position', 'relative')
          .style('width', scope.width + MARGIN.left + MARGIN.right)
          .style('height', height + MARGIN.top + MARGIN.bottom)

        timetableArea = base.append('div')
          .style('position', 'relative')
          .attr('class', 'timetable-area')
          .style('left', MARGIN.left + "px")
          .style('top', MARGIN.top + "px")

        venueList = timetableArea.append('ul').attr('class', 'venue-list')

        venueTitles = venueList.selectAll('li.venue-title')
          .data(scope.filteredVenueNames)

        venueTitles.enter().append('li')
          .style('opacity', 0)
          .style('position', 'absolute')
          .style('text-align', 'center')
          .attr('class', 'venue-title')
          .attr('id', (v) -> 'venue-' + v)
          .style('list-style-type', 'none')
          .style('height', ROW_HEIGHT + "px")
          .style('left', (v) -> xScale(v) + "px")
          .style('top', "-30px")
          .style('width', EVENT_BOX_WIDTH + "px")
          .transition().duration(250).style('opacity', 1)
          .text((v) -> v)
          .style('color', 'white')

        yAxis = timetableArea.append('ul').attr('class', 'y-axis')
          .style('padding', '0')

        timeslotList = yAxis.selectAll('li.timeslot')
          .data(timeslots, (t) -> t.time)

        timeslotList.enter().append('li')
          .style('opacity', 0)
          .attr('class', 'timeslot')
          .attr('id', (t) -> 'timeslot-' + t)
          .style('list-style-type', 'none')
          .style('height', ROW_HEIGHT + "px")
          .style('left', "0px")
          .style('width', scope.width + "px")
          .style('border-top', '1px dotted rgba(255, 255, 255, 0.1)')
          .transition().duration(250).style('opacity', 1)

        timeslotList.append('text')
          .style('opacity', 0)
          .attr('class', 'time')
          .text((t) -> findTime(t.time))
          .style('color', 'white')
          .style('float', 'left')
          .transition().duration(250).style('opacity', 1)

        timetableArea.selectAll('path.domain').style("opacity", "0")

        # Create events
        eventBoxes = timetableArea.selectAll('div.event-wrapper')
          .data(scope.filteredEvents, (e) -> e.id)

        eventBoxes.enter().append('div')
          .attr('class', (e) ->
            if _(scope.events).findWhere({id: e.id}).selected
              'event-wrapper selected'
            else
              'event-wrapper'
          )
          .attr('id', (e) -> 'event-' + e.id)
          .style('width', (EVENT_BOX_WIDTH - BOX_H_MARGIN * 2) + "px")
          .style('height', (e) -> (calculateEventHeight(e) - BOX_V_MARGIN * 2) + "px")
          .style('top', (e) -> (yScale(Date.parse(e.start_time)) + BOX_V_MARGIN) + "px")
          .style('left', (e) -> (xScale(e.venue.name) + BOX_H_MARGIN) + "px")
          .html((e) ->
            venue_name = if e.venue then e.venue.name
            "
              <div class='name'>#{e.artist.name}</div>
            "
          ).on('click', (e) ->
            box = d3.select(this)
            originalEvent = _(scope.events).findWhere({id: e.id})
            if originalEvent.selected
              removeEventFromSchedule(e)
              originalEvent.selected = false
              box.attr('class', 'event-wrapper')
            else
              addEventToSchedule(e)
              originalEvent.selected = true
              box.attr('class', 'event-wrapper selected')
          )

        eventBoxes
          .append('button')
          .on('click', (e) ->
            scope.$emit('selectArtist', e.artist)
            d3.event.stopPropagation()
          ).append('div').attr('class', 'play').text('Play')

      shiftTimeTable = ->
        scope.filteredDaysEvents = filterEventsByDay(scope.events, scope.day)
        scope.filteredVenueNames = scope.venues
        scope.filteredEvents = filterEventsByVenue(scope.filteredDaysEvents, scope.venues)
        xScale.domain(scope.filteredVenueNames).rangeBands([60, scope.width], 0, 0)

        base = d3.select(element[0]).select('div.timetable')
        timetableArea = base.select('div.timetable-area')
        venueList = timetableArea.select('ul.venue-list')
        venueTitles = venueList.selectAll('li.venue-title')
          .data(scope.filteredVenueNames, (d) -> d)

        eventBoxes = timetableArea.selectAll('div.event-wrapper')
          .data(scope.filteredEvents, (e) -> e.id)

        eventBoxes.exit().transition()
            .duration(250)
            .style('opacity', 0)
          .transition()
            .remove()

        eventBoxes.enter().append('div')
          .style('opacity', 0)
          .attr('class', (e) ->
            if _(scope.events).findWhere({id: e.id}).selected
              'event-wrapper selected'
            else
              'event-wrapper'
          )
          .attr('id', (e) -> 'event-' + e.id)
          .style('width', (EVENT_BOX_WIDTH - BOX_H_MARGIN * 2) + "px")
          .style('height', (e) -> (calculateEventHeight(e) - BOX_V_MARGIN * 2) + "px")
          .style('top', (e) -> (yScale(Date.parse(e.start_time)) + BOX_V_MARGIN) + "px")
          .html((e) ->
            venue_name = if e.venue then e.venue.name
            "
              <div class='name'>#{e.artist.name}</div>
            "
          ).on('click', (e) ->
            box = d3.select(this)
            originalEvent = _(scope.events).findWhere({id: e.id})
            if originalEvent.selected
              removeEventFromSchedule(e)
              originalEvent.selected = false
              box.attr('class', 'event-wrapper')
            else
              addEventToSchedule(e)
              originalEvent.selected = true
              box.attr('class', 'event-wrapper selected')
          )
          .append('button')
          .on('click', (e) ->
            scope.$emit('selectArtist', e.artist)
            d3.event.stopPropagation()
          ).append('div').attr('class', 'play').text('Play')

        eventBoxes.transition()
          .duration(250)
            .style('left', (e) -> (xScale(e.venue.name) + BOX_H_MARGIN) + "px")
          .transition()
            .style('opacity', 1)

        venueTitles.exit()
          .transition().duration(250)
          .style('opacity', 0)
          .remove()

        venueTitles.enter()
          .append('li')
            .style('position', 'absolute')
            .style('text-align', 'center')
            .attr('class', 'venue-title')
            .attr('id', (v) -> 'venue-' + v)
            .style('list-style-type', 'none')
            .style('height', ROW_HEIGHT + "px")
            .style('top', "-30px")
            .style('width', EVENT_BOX_WIDTH + "px")
            .style('opacity', 0)
            .text((v) -> v)
            .style('color', 'white')

        venueTitles
          .transition()
          .style('opacity', 1)
          .style('left', (v) -> xScale(v) + "px")
          .duration(250)

      addEventToSchedule = (newEvent) -> scope.$emit('addEvent', newEvent)
      removeEventFromSchedule = (oldEvent) -> scope.$emit('removeEvent', oldEvent)

  # Helper Methods
  calculateTimeslots = (minTime, maxTime) ->
    blocks = Math.ceil((maxTime - minTime) / MILLISECONDS_PER_BLOCK)
    timeslots = []
    _(blocks).times((i) -> timeslots.push({time: minTime + i * MILLISECONDS_PER_BLOCK}))
    timeslots

  calculateEventHeight = (event) ->
    start_time = Date.parse(event.start_time)
    end_time = Date.parse(event.end_time)
    (end_time - start_time) * ROW_HEIGHT / MILLISECONDS_PER_BLOCK

  filterEventsByDay = (events, day) ->
    newDay = new Date(day)
    dayStart = new Date(new Date(newDay.setHours(0)).setMinutes(0))
    dayEnd = new Date(new Date(newDay.setHours(23)).setMinutes(59))
    _(events).select (e) ->
      new Date(e.start_time) <= dayEnd && new Date(e.start_time) >= dayStart

  filterEventsByVenue = (events, venues) ->
    _(events).filter((e) -> _(venues).contains(e.venue.name))

  findTime = (time) ->
    time = new Date(time)
    Time.format12Hour(time)

  timetable

]
