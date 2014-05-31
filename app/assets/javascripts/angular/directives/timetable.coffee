app.directive 'timetable', ($window) ->
  MARGIN = {top: 50, right: 20, bottom: 50, left: 20}
  ROW_HEIGHT = 50
  MILLISECONDS_PER_BLOCK = 900000 # 15 Minutes

  timetable =
    restrict: 'A'
    scope:
      festival: '='

    link: (scope, element, attrs) ->
      scope.$watch 'festival', ->
        if scope.festival
          setupTimetable()

      window = angular.element($window)
      window.bind 'resize', () ->
        resizeTimetable()

      yScale = d3.time.scale()
      xScale = d3.scale.ordinal()

      setupTimetable = ->
        venueNames = _(scope.festival.venues).pluck('name')
        events = _(scope.festival.venues).chain().pluck('events').flatten().value()
        minTime = _(events).chain().pluck('start_time').map((t) -> Date.parse(t)).min().value()
        maxTime = _(events).chain().pluck('end_time').map((t) -> Date.parse(t)).max().value()

        timeslots = calculateTimeslots(minTime, maxTime)
        height = (timeslots.length * ROW_HEIGHT)
        width = $(element[0]).width() - MARGIN.left - MARGIN.right
        eventBoxWidth = (width - 60) / scope.festival.venues.length

        # Adjust the scales / axis
        yScale.range([0, height]).domain([minTime, maxTime])
        xScale.domain(venueNames).rangeBands([60, width], 0)

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
          .style('padding', '0')

        venueTitles = venueList.selectAll('li.venue-title')
          .data(venueNames)

        venueTitles.enter().append('li')
          .style('position', 'absolute')
          .style('text-align', 'center')
          .attr('class', 'venue-title')
          .attr('id', (v) -> 'venue-' + v)
          .style('list-style-type', 'none')
          .style('height', ROW_HEIGHT + "px")
          .style('left', (v) -> xScale(v) + "px")
          .style('top', (-MARGIN.top / 2) + "px")
          .style('width', eventBoxWidth + "px")

        venueTitles.append('text')
          .text((v) -> v)
          .style('color', 'white')

        yAxis = timetableArea.append('ul').attr('class', 'y-axis')
          .style('padding', '0')

        timeslotList = yAxis.selectAll('li.timeslot')
          .data(timeslots, (t) -> t.time)

        timeslotList.enter().append('li')
          .attr('class', 'timeslot')
          .attr('id', (t) -> 'timeslot-' + t)
          .style('list-style-type', 'none')
          .style('height', ROW_HEIGHT + "px")
          .style('left', "0px")
          .style('width', width + "px")
          .style('border-top', '1px white solid')

        timeslotList.append('text')
          .attr('class', 'time')
          .text((t) -> findTime(t.time))
          .style('color', 'white')

        timetableArea.selectAll('path.domain').style("opacity", "0")

        # Create events
        eventBoxes = timetableArea.selectAll('div.eventBox')
          .data(events, (e) -> e.id)

        eventBoxes.enter().append('div')
          .attr('class', 'eventBox')
          .attr('id', (e) -> 'event-' + e.id)
          .style('position', 'absolute')
          .style('width', eventBoxWidth + "px")
          .style('top', (e) -> yScale(Date.parse(e.start_time)) + "px")
          .style('left', (e) -> xScale(e.venue_name) + "px")
          .style('border', '1px grey solid')
          .style('text-align', 'center')
          .style('background', 'rgba(0,0,0,0.7)')
          .transition().duration(250)
          .style('height', (e) -> calculateEventHeight(e) + "px")

        eventBoxes.append('text')
          .attr('class', 'artist-name')
          .text((e) -> e.artist.name)
          .style('color', 'white')

        eventBoxes.append('a')
          .attr('href', 'javascript:void(0)')
          .text('Add to Schedule')
          .on('click', (e) ->
            addEventToSchedule(e)
          )

      resizeTimetable = ->
        # Update all widths and scales dependent on width
        width = $(element[0]).width() - MARGIN.left - MARGIN.right
        eventBoxWidth = (width - 60) / scope.festival.venues.length
        xScale.rangeBands([60, width], 0)

        # Update the size of the timeslots
        d3.select('div.timetable').style('width', width + MARGIN.left + MARGIN.right)
        d3.select('div.timetable-area').style('width', width)
        d3.select('div.timetable-area').selectAll('li.timeslot').style('width', width + "px")
        d3.select('div.timetable-area').selectAll('li.venue-title')
          .style('width', eventBoxWidth + "px")
          .style('left', (v) -> xScale(v) + "px")

        # Update the boxes
        d3.selectAll('div.eventBox')
          .style('width', eventBoxWidth + "px")
          .style('left', (e) -> xScale(e.venue_name) + "px")

      addEventToSchedule = (newEvent) -> scope.$emit('addEventToSchedule', newEvent)

  # Helper Methods
  calculateTimeslots = (minTime, maxTime) ->
    blocks = (maxTime - minTime) / MILLISECONDS_PER_BLOCK
    timeslots = []
    _(blocks).times((i) -> timeslots.push({time: minTime + i * MILLISECONDS_PER_BLOCK}))
    timeslots

  calculateEventHeight = (event) ->
    start_time = Date.parse(event.start_time)
    end_time = Date.parse(event.end_time)
    (end_time - start_time) * ROW_HEIGHT / MILLISECONDS_PER_BLOCK

  findTime = (time) ->
    time = new Date(time)
    minutes = (if time.getMinutes() < 10 then '0' else '') + time.getMinutes()
    "#{time.getHours()}:#{minutes}"

  timetable
