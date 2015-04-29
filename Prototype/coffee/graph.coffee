$ ->
  running = true
  width = document.documentElement.clientWidth * 0.3
  height = document.documentElement.clientHeight * 0.8

  n = 100
  t = 10
  data = [50]

  x = d3.scale.linear()
    .domain [0, data.length]
    .range [0, width]

  y = d3.scale.linear()
    .domain [0, n]
    .rangeRound [0, height]

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
      # .attr "width", (d, i) -> x(i)
      .attr 'width', w()
      .attr "height", (d) -> y(d)

  redraw = ->
    rect = chart.selectAll('rect')
      .data(data)
    rect.enter()
        .insert('svg:rect', 'line')
        .attr 'x', (d, i) -> x(i)
        .attr 'y', (d) -> height - y(d)
        # .attr 'width', (d, i) -> x(i)
        .attr 'width', w()
        .attr 'height', (d) -> y(d)
      .transition()
        .duration t
        .attr 'x', (d, i) -> x(i)
    rect
      .transition()
      .duration t
      .attr 'x', (d, i) -> x(i)
      .attr 'y', (d) -> height - y(d)
      # .attr 'width', (d, i) -> x(i)
      .attr 'width', w()
      .attr 'height', (d) -> y(d)
    # rect.exit()
    # .transition()
    #     .duration(1000)
    #     .attr 'x', (d, i) -> x(i - 1)
    #   .remove()
    return

  $('*').keypress ->
    running = !running
  setInterval ->
    if !running
      return
    data.push Math.random() * n/2 + n/3
    x.domain [0, data.length]
    #y.domain [0, d3.max(data)]
    #i += 1
    console.log data
    console.log n
    redraw()
  , t
