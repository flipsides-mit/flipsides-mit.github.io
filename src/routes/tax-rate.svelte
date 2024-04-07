<script>
  import { onMount } from 'svelte';
  import { fade } from 'svelte/transition';
  import * as d3 from 'd3';

  let data = [];
  let width = 0;
  let height = 0;

  $: margin = {
	top: height * 0.3,
	right: width * 0.05,
	bottom: height * 0.3,
	left: width * 0.2,
  };

  $: xScale = d3.scaleLinear()
  .domain([0, d3.max(data, d => d.price)]).nice()
  .range([margin.left, width - margin.right]);

  $: yScale = d3.scaleLinear()
  .domain([0, d3.max(data, d => d.rate * 5)]).nice()
  .range([height - margin.bottom, margin.top]);

  let color = {
	residential: "#6699CC",
	commercial: "#DDCC77",
	other: "#44AA99"
  }

  let svg;

  let xAxis;
  $: {
	let sel = d3.select(xAxis)
		.style('font-family', 'inherit')
		.call(d3.axisBottom(xScale).ticks(5, "d").tickSizeOuter(0));

	sel.selectAll('path')
	  .attr('stroke-width', '1px');

	sel.selectAll('.tick > text')
	  .attr('font-size', `${width * 0.025}px`);
  }

  let yAxis;
  $: {
	let sel = d3.select(yAxis)
		.attr('font-weight', '300')
		.style('font-family', 'inherit')
		.call(d3.axisLeft(yScale).ticks(5, ".1f"));

	sel.selectAll('path')
	  .style('stroke-width', '1px');

	sel.selectAll('.tick > text')
	  .style('font-size', `${width * 0.025}px`);
  }

  // Gridlines
  $: d3.select(svg)
  .selectAll('line.xgridline')
  .data(yScale.ticks(5))
  .join('line')
  .classed('xgridline', true)
  .transition()
  .duration(300)
  .attr('x1', margin.left)
  .attr('x2', width - margin.right)
  .attr('y1', d => yScale(d))
  .attr('y2', d => yScale(d))
  // we can also put things below under :global(xgridline) in CSS
  .attr('shape-rendering', 'crispEdges')
  .attr('stroke', 'black')
  .attr('stroke-width', '1px')
  // dotted line
  .attr('stroke-dasharray', '1, 5');

   $: d3.select(svg)
  .selectAll('line.ygridline')
  .data(xScale.ticks(5))
  .join('line')
  .classed('ygridline', true)
  .transition()
  .duration(300)
  .attr('x1', d => xScale(d))
  .attr('x2', d => xScale(d))
  .attr('y1', margin.top)
  .attr('y2', height - margin.bottom)
  // we can also put things below under :global(ygridline) in CSS
  .attr('shape-rendering', 'crispEdges')
  .attr('stroke', 'black')
  .attr('stroke-width', '1px')
  // dotted line
  .attr('stroke-dasharray', '1, 5');

  let points = [];
  $: {
	points = data.map(d => [xScale(d.price), yScale(d.rate), "1x"]);
	points = points.concat(data.map(d => [xScale(d.price), yScale(d.rate * 3), "3x"]));
	points = points.concat(data.map(d => [xScale(d.price), yScale(d.rate * 5), "5x"]));
	console.log('points', points)
  }
  $: groups = d3.rollup(points, v => Object.assign(v, {z: v[0][2]}), d => d[2]);
  $: console.log(groups)

  let linesg;

  let line = d3.line();
  $: path = d3.select(linesg)
  .selectAll("path")
  .data(groups.values())
  .join("path")
  .style("mix-blend-mode", "multiply")
  .attr("d", line);

  onMount(async () => {
	data = await d3.csv('/tax-rate.csv', d => { return {
	  ...d,
	  price: +d.price,
	  rate: +d.rate,
	}});
	console.log('Loaded data:', data)
  });
</script>

<div class="container" bind:clientWidth={width} bind:clientHeight={height}>
  <svg bind:this={svg} width="100%" height="100%" style="font-weight: 300;">
	<g transform="translate(0, {height - margin.bottom})"
	   bind:this={xAxis} />

	<g transform="translate({margin.left}, 0)"
	   bind:this={yAxis} />

	<g bind:this={linesg} class="line">
	</g>
  </svg>
</div>

<style>
  .container {
	display: flex;
	justify-content: center;
	align-items: center;
	width: 100%;
	height: 100%;
  }
  .line {
	fill: none;
	stroke: steelblue;
	stroke-width: 1.5;
	stroke-linejoin: round;
	stroke-linecap: round;
  }
</style>
