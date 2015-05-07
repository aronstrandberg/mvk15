$ ->
  width = document.documentElement.clientWidth * 0.3
  height = document.documentElement.clientHeight * 0.8

  n = 4
  datatype = "velocity"
  data = window.data[datatype]

  x = d3.scale.linear()
    .domain [0, data.length]
    .range [0, width]

  y = d3.scale.linear()
    # .domain [0, n]
    .rangeRound [0, height]

  # color = d3.scale.linear()
  #   .domain [0, n]
  #   .range colorbrewer.Reds[9]

  w = ->
    width/data.length
 
  chart = d3.select "#chart"
    .append "svg:svg"
      .attr "width", width
      .attr "height", height

  chart.selectAll "rect"
      .data(data)
    .enter()
      .append "svg:rect"
      .attr "x", (d, i) -> x(i)
      .attr "y", (d) -> height - y(d)
      .attr 'width', w()
      .attr "height", (d) -> y(d)

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
      .transition()
        .duration 500
        .attr 'fill', "#ff4444"
    # rect.exit()
    # .transition()
    #     .duration(1000)
    #     .attr 'x', (d, i) -> x(i - 1)
    #   .remove()
    return
  refresh = ->
    data = window.data[datatype]
    x.domain [0, data.length]
    y.domain [0, Math.max.apply(null, data)]
    redraw()
  
  setInterval(refresh, window.interval)
