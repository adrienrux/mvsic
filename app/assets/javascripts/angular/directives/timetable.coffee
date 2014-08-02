app.directive 'timetable', ['$window', 'Time', ($window, Time) ->
  MARGIN = {top: 0, right: 20, bottom: 50, left: 20}
  ROW_HEIGHT = 40
  MILLISECONDS_PER_BLOCK = 900000 # 15 Minutes
  BOX_H_MARGIN = 2
  BOX_V_MARGIN = 4

  timetable =
    restrict: 'A'
    scope:
      festival: '='
      day: '='

    link: (scope, element, attrs) ->
      scope.$watch 'festival', ->
        if scope.festival
          scope.events = scope.festival.events

      scope.$watch 'day', ->
        if scope.events && scope.day != 'All'
          setupTimetable()
        else if scope.events
          setupList()

      scope.$on 'deselectEvent', (event, data) ->
        deselectedEvent = _(scope.events).findWhere({id: data.id})
        deselectedEvent.selected = false
        d3.select("div.event-wrapper#event-#{data.id}").attr('class', 'event-wrapper')

      window = angular.element($window)
      window.bind 'resize', () ->
        if scope.day != 'All'
          resizeTimetable()
        else
          resizeList()

      yScale = d3.time.scale()
      xScale = d3.scale.ordinal()

      setupTimetable = ->
        scope.filteredEvents = filterEventsByDay(scope.events, scope.day)
        scope.venueNames = _(scope.filteredEvents).chain().pluck('venue').pluck('name').uniq().value()
        minTime = _(scope.filteredEvents).chain().pluck('start_time').map((t) -> Date.parse(t)).min().value()
        maxTime = _(scope.filteredEvents).chain().pluck('end_time').map((t) -> Date.parse(t)).max().value()

        timeslots = calculateTimeslots(minTime, maxTime)
        height = (timeslots.length * ROW_HEIGHT)
        width = $(element[0]).width() - MARGIN.left - MARGIN.right
        eventBoxWidth = (width - 60) / scope.venueNames.length

        # Adjust the scales / axis
        yScale.range([0, height]).domain([minTime, maxTime])
        xScale.domain(scope.venueNames).rangeBands([60, width], 0)

        d3.select(element[0]).select('div.timetable')
          .transition().duration(250).style('opacity', 0).remove()

        base = d3.select(element[0]).append('div')
          .attr('class', 'timetable')
          .style('position', 'relative')
          .style('width', width + MARGIN.left + MARGIN.right)
          .style('height', height + MARGIN.top + MARGIN.bottom)

        timetableArea = base.append('div')
          .style('position', 'relative')
          .attr('class', 'timetable-area')
          .style('left', MARGIN.left + "px")
          .style('top', MARGIN.top + "px")

        venueList = timetableArea.append('ul').attr('class', 'venue-list')

        venueTitles = venueList.selectAll('li.venue-title')
          .data(scope.venueNames)

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
          .style('width', eventBoxWidth + "px")
          .transition().duration(250).style('opacity', 1)

        venueTitles.append('text')
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
          .style('width', width + "px")
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
          .style('opacity', 0)
          .attr('class', (e) ->
            if _(scope.events).findWhere({id: e.id}).selected
              'event-wrapper selected'
            else
              'event-wrapper'
          )
          .attr('id', (e) -> 'event-' + e.id)
          .style('width', (eventBoxWidth - BOX_H_MARGIN * 2) + "px")
          .style('height', (e) -> (calculateEventHeight(e) - BOX_V_MARGIN * 2) + "px")
          .style('top', (e) -> (yScale(Date.parse(e.start_time)) + BOX_V_MARGIN) + "px")
          .style('left', (e) -> (xScale(e.venue.name) + BOX_H_MARGIN) + "px")
          .html((e) ->
            venue_name = if e.venue then e.venue.name
            "
              <p class='name'>#{e.artist.name}</p>
              <p class='venue'>#{venue_name}</p>
              <p class='play-count'>Played: #{e.artist.count}</p>
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
          ).transition().duration(250).style('opacity', 1)

        eventBoxes
          .append('button')
          .on('click', (e) ->
            scope.$emit('selectArtist', e.artist)
            d3.event.stopPropagation()
          ).append('div').attr('class', 'play')

      setupList = ->
        scope.filteredEvents = filterEventsByDay(scope.events, scope.day)
        height = (Math.ceil(scope.filteredEvents.length / 3) * ROW_HEIGHT * 4)
        width = $(element[0]).width() - MARGIN.left - MARGIN.right
        eventBoxWidth = "#{100 / 4 - 1}%"
        eventBoxHeight = ROW_HEIGHT * 3
        d3.select(element[0]).select('div.timetable')
          .transition().duration(250).style('opacity', 0).remove()

        base = d3.select(element[0]).append('div')
          .attr('class', 'timetable')
          .style('position', 'relative')
          .style('width', width + MARGIN.left + MARGIN.right)
          .style('height', height + MARGIN.top + MARGIN.bottom)

        timetableArea = base.append('div')
          .style('position', 'relative')
          .attr('class', 'timetable-area')
          .style('left', MARGIN.left + "px")
          .style('top', MARGIN.top + "px")

        # Create events
        eventBoxes = timetableArea.selectAll('div.event-wrapper')
          .data(scope.filteredEvents, (e) -> e.id)

        eventBoxes.enter().append('div')
          .style('opacity', 0)
          .attr('class', (e) ->
            if _(scope.events).findWhere({id: e.id}).selected
              'event-wrapper selected'
            else
              'event-wrapper'
          )
          .attr('id', (e) -> 'event-' + e.id)
          .style('width', eventBoxWidth)
          .style('height', (e) -> (eventBoxHeight - BOX_V_MARGIN * 2) + "px")
          .style('position', 'relative')
          .style('float', 'left')
          .style('margin', "#{BOX_H_MARGIN}px")
          .html((e) ->
            venue_name = if e.venue then e.venue.name else ''
            "
              <p class='name'>#{e.artist.name}</p>
              <p class='venue'>#{venue_name}</p>
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
          ).transition().duration(250).style('opacity', 1)
        
        eventBoxes
          .append('button')
          .on('click', (e) ->
            scope.$emit('selectArtist', e.artist)
            d3.event.stopPropagation()
          )
          .append('div').attr('class', 'play')

      resizeTimetable = ->
        # Update all widths and scales dependent on width
        width = $(element[0]).width() - MARGIN.left - MARGIN.right
        eventBoxWidth = (width - 60) / scope.venueNames.length
        xScale.rangeBands([60, width], 0)

        # Update the size of the timeslots
        d3.select('div.timetable').style('width', width + MARGIN.left + MARGIN.right)
        d3.select('div.timetable-area').style('width', width)
        d3.select('div.timetable-area').selectAll('li.timeslot').style('width', width + "px")
        d3.select('div.timetable-area').selectAll('li.venue-title')
          .style('width', eventBoxWidth + "px")
          .style('left', (v) -> xScale(v) + "px")

        # Update the boxes
        d3.selectAll('div.event-wrapper')
          .style('width', (eventBoxWidth - BOX_H_MARGIN * 2) + "px")
          .style('left', (e) -> (xScale(e.venue.name) + BOX_H_MARGIN) + "px")

      resizeList = ->
        height = (Math.ceil(scope.filteredEvents.length / 4) * ROW_HEIGHT * 4)
        width = $(element[0]).width() - MARGIN.left - MARGIN.right
        eventBoxWidth = "#{100 / 4 - 1}%"

        d3.select('div.timetable').style('width', width + MARGIN.left + MARGIN.right)
        d3.select('div.timetable-area').style('width', width)

        d3.selectAll('div.event-wrapper')
          .style('width', eventBoxWidth)

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
    unless day == 'All'
      newDay = new Date(day)
      dayStart = new Date(new Date(newDay.setHours(0)).setMinutes(0))
      dayEnd = new Date(new Date(newDay.setHours(23)).setMinutes(59))
      _(events).select (e) ->
        new Date(e.start_time) <= dayEnd && new Date(e.start_time) >= dayStart
    else
      _(events).sortBy((e) -> e.artist.name)

  findTime = (time) ->
    time = new Date(time)
    Time.format12Hour(time)

  timetable

]
