$ ->
  # set size of the graph window
  width = document.documentElement.clientWidth * 0.3
  height = document.documentElement.clientHeight * 0.8
  # decide what data to graph
  datatype = "velocity"
  # set data variable to access stored data
  data = window.data[datatype]

  # creates a scaling function that determines horizontal location in the graph
  x = d3.scale.linear()
    .domain [0, data.length]
    .range [0, width]

  # creates a scaling function that determines height of a bar
  y = d3.scale.linear()
    .rangeRound [0, height]

  # calculate width of a bar
  w = ->
    width/data.length
 
 # selects the #chart element
  chart = d3.select "#chart"
    # append an svg element to the DOM
    .append "svg:svg"
      # set size
      .attr "width", width
      .attr "height", height
  # associate the data with rect elements
  chart.selectAll "rect"
      .data(data)
    # select only new data
    .enter()
      # append a rect element for every piece of data and set attributes
      .append "svg:rect"
      .attr "x", (d, i) -> x(i)
      .attr "y", (d) -> height - y(d)
      .attr 'width', w()
      .attr "height", (d) -> y(d)

  # redraw the graph with new data
  redraw = ->
    rect = chart.selectAll('rect')
      .data(data)
    rect.enter()
        .insert('svg:rect', 'line')
        .attr 'x', (d, i) -> x(i)
        .attr 'y', (d) -> height - y(d)
        .attr 'width', w()
        .attr 'height', (d) -> y(d)
      .transition()
        .duration window.interval
        .attr 'x', (d, i) -> x(i)
    rect
      .transition()
        .duration window.interval
        .attr 'x', (d, i) -> x(i)
        .attr 'y', (d) -> height - y(d)
        .attr 'width', w()
        .attr 'height', (d) -> y(d)
    return
  # update the graph with new data
  refresh = ->
    # get new data
    data = window.data[datatype]
    # updates scaling function to account for new number of data pieces
    x.domain [0, data.length]
    y.domain [0, Math.max.apply(null, data)]
    # draw it again
    redraw()
  
  # updates the graph at the given interval
  setInterval(refresh, window.interval)
