$ ->
  width = document.documentElement.clientWidth * 0.3
  height = document.documentElement.clientHeight * 0.8

  n = 20
  window.data = [5]

  x = d3.scale.linear()
    .domain [0, data.length]
    .range [0, width]

  y = d3.scale.linear()
    .domain [0, n]
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
      # .attr "fill", c()

  redraw = ->
    if !window.running
      return
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
    # rect.exit()
    # .transition()
    #     .duration(1000)
    #     .attr 'x', (d, i) -> x(i - 1)
    #   .remove()
    return

  $('*').click ->
    window.running = !window.running
  setInterval ->
    x.domain [0, data.length]
    redraw()
  , window.interval
