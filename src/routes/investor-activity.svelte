<script>
  import { onMount } from 'svelte';
  import { fade } from 'svelte/transition';
  import * as d3 from 'd3';
  import { seldatap, seldataq } from './stores.js';

  export let phase = 0;
  export let colorp, colorq;
  let dataraw = [];
  
  function toProfit(d) {
	let diff = d.current_price - d.previous_price;
	let profit = diff / d.previous_price / d.year_diff * 100;
	return {
	  price: d.current_price,
	  profit: profit,
	  year: d.year_diff,
	  investor: d.investor,
	}
  }

  $: data = dataraw.map(toProfit);
  
  let width = 0;
  let height = 0;

  $: margin = {
	top: height * 0.1,
	right: width * 0.05,
	bottom: height * 0.1,
	left: width * 0.1,
  };

  $: xScale = d3.scaleLinear()
  // .domain([0, d3.max(data, d => d.price)])
  .domain([0, 4000000]).nice()
  .range([margin.left, width - margin.right])
  .clamp(true);

  $: xScaleReady = !isNaN(xScale.domain()[1])

  $: yScale = d3.scaleLinear()
  .domain([0, 25])
  .range([height - margin.bottom, margin.top])
  .clamp(true);

  let xAxis;
  let yAxis;

  $: {
	let sel = d3.select(xAxis)
		.style('font-family', 'inherit')
		.transition().duration(300)
		.call(d3.axisBottom(xScale).ticks(5, "f"))

	// Update the thickness of the axis line
	sel.selectAll('path')
	  .attr('stroke-width', '1px');

	sel.selectAll('.tick > text')
	  .attr('font-size', `${width * 0.025}px`);
  }

  $: {
	let sel = d3.select(yAxis)
		.style('font-family', 'inherit')
		.transition().duration(300)
		.call(d3.axisLeft(yScale).ticks(5, "f"))

	// Update the thickness of the axis line
	sel.selectAll('path')
	  .style('stroke-width', '1px');

	sel.selectAll('.tick > text')
	  .style('font-size', `${width * 0.025}px`);
  }

  let svg;

  // Draw data points
  $: d3.select(svg)
  .selectAll('circle')
  .data(data)
  .join('circle')
  // .transition()
  // .duration(1000)
  .attr('cx', d => xScale(d.price))
  .attr('cy', d => yScale(d.year))
  .attr('r', 1.5)
  .attr("stroke", "#000")
  .attr("stroke-opacity", 0.2)
  .style('fill-opacity', 0.4)
  .style('fill', d => d.investor ? '#EE8866' : '#DDDDDD');

  // Grid lines
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

  // Brushes.
  let brushp;
  let brushq;
  // [[x0, y0], [x1, y1]]
  // Note that y0 > y1
  let rangep = [[0, 0], [0, 0]];
  let rangeq = [[0, 0], [0, 0]];
  let brushes = [];

  function disableBrush(brushid) {
	if (brushid == 0) {
	  d3.select(brushq)
		.select('.overlay')
		.attr('pointer-events', 'all');
	  d3.select(brushp)
		.select('.overlay')
		.attr('pointer-events', 'none');
	} else if (brushid == 1) {
	  d3.select(brushp)
		.select('.overlay')
		.attr('pointer-events', 'all');
	  d3.select(brushq)
		.select('.overlay')
		.attr('pointer-events', 'none');
	}
  }

  function brushed({selection}, brushid) {
	console.log(`Brush ${brushid} Selection:`, selection);
	if (!selection) {
	  // TODO: there's a delay, fix this.
	  d3.select(brushp).call(brushes[0].move, [[0,0],[0,0]]);
	  d3.select(brushq).call(brushes[1].move, [[0,0],[0,0]]);
	  disableBrush(1);
	  return;
	}
	
    const [[x0, y0], [x1, y1]] = selection;
	let range = [[xScale.invert(x0), yScale.invert(y1)],
			  [xScale.invert(x1), yScale.invert(y0)]];

	let sel = data.filter(d =>
	  range[0][0] <= d.price &&
		d.price <= range[1][0] &&
		range[0][1] <= d.year &&
		d.year <= range[1][1]);

	if (brushid == 0) {
	  rangep = range;
	  seldatap.set(sel);
      console.log("Selected Data (brushp):", sel);
	} else {
	  rangeq = range;
	  seldataq.set(sel);
      console.log("Selected Data (brushq):", sel);
	}

	disableBrush(brushid);
  }

  // Brush updates triggered on height/width resizing.
  $: {
	brushes = [
	  d3.brush()
		.extent([[margin.left, margin.top], [width - margin.right, height - margin.bottom]])
		.on("end", e => brushed(e, 0)),
	  d3.brush()
		.extent([[margin.left, margin.top], [width - margin.right, height - margin.bottom]])
		.on("end", e => brushed(e, 1))
	];

	d3.select(brushp).call(brushes[0]);
	d3.select(brushq).call(brushes[1]);

	d3.select(brushp)
	  .select('.selection')
	  .attr('fill', colorp);

	d3.select(brushq)
	  .select('.selection')
	  .attr('fill', colorq);
  }

  function resetBrushesLocation() {
	d3.select(brushp)
	  .call(brushes[0].move, [[xScale(0),yScale(0)],[xScale(0),yScale(0)]]);
	d3.select(brushq)
	  .call(brushes[1].move, [[xScale(0),yScale(0)],[xScale(0),yScale(0)]]);
  }

  let d = 300;

  function drawFinding(n) {
	if (n == 0) {
	  resetBrushesLocation()
	} else if (n == 1) {
	  d3.select(brushp)
		.transition()
		.duration(d)
	  	.call(brushes[0].move, [[xScale(0),yScale(25)],[xScale(1000000),yScale(0)]]);
	  d3.select(brushq)
		.transition()
		.duration(d)
		.call(brushes[1].move, [[xScale(1000000),yScale(25)],[xScale(2000000),yScale(0)]]);
	} else if (n == 2) {
	  d3.select(brushp)
		.transition()
		.duration(d)
	  	.call(brushes[0].move, [[xScale(0),yScale(25)],[xScale(1000000),yScale(0)]]);
	  d3.select(brushq)
		.transition()
		.duration(d)
		.call(brushes[1].move, [[xScale(2000000),yScale(25)],[xScale(3000000),yScale(0)]]);
	} else if (n == 3) {
	  d3.select(brushp)
		.transition()
		.duration(d)
	  	.call(brushes[0].move, [[xScale(0),yScale(25)],[xScale(1000000),yScale(0)]]);
	  d3.select(brushq)
		.transition()
		.duration(d)
		.call(brushes[1].move, [[xScale(3000000),yScale(25)],[xScale(4000000),yScale(0)]]);
	} else if (n == 4) {
	  d3.select(brushp)
		.transition()
		.duration(d)
	  	.call(brushes[0].move, [[xScale(0),yScale(25)],[xScale(4000000),yScale(0)]]);
	  d3.select(brushq)
		.transition()
		.duration(d)
		.call(brushes[1].move, [[xScale(0),yScale(2)],[xScale(4000000),yScale(0)]]);
	} else if (n == 5) {
	  d3.select(brushp)
		.transition()
		.duration(d)
	  	.call(brushes[0].move, [[xScale(0),yScale(2)],[xScale(4000000),yScale(0)]]);
	  d3.select(brushq)
		.transition()
		.duration(d)
		.call(brushes[1].move, [[xScale(0),yScale(2)],[xScale(4000000),yScale(0)]]);
	} else if (n == 6) {
	  d3.select(brushp)
		.transition()
		.duration(d)
	  	.call(brushes[0].move, [[xScale(0),yScale(2)],[xScale(4000000),yScale(0)]]);
	  d3.select(brushq)
		.transition()
		.duration(d)
		.call(brushes[1].move, [[xScale(1000000),yScale(2)],[xScale(4000000),yScale(0)]]);
	}
  }

  // Actions performed when this component is created.
  onMount(async () => {
	dataraw = await d3.csv('/2022_mapc.csv', d => { return {
	  ...d,
	  current_price: +d.current_price,
	  previous_price: +d.previous_price,
	  investor: d.investor === 'True',
	  year: +d.year
	}});

	console.log('Number of data points:', dataraw.length)

	// Disable the second brush.
	resetBrushesLocation();
	disableBrush(1);
  });

  $: drawFinding(phase);

  // Debug.
  $: console.log(`Dimension: ${width}, ${height}`);
  // $: console.log(data)
</script>

<div class="container" bind:clientWidth={width} bind:clientHeight={height}>
  <svg bind:this={svg} width="100%" height="100%" font-weight="300">
	<g transform="translate(0, {height - margin.bottom})"
	   bind:this={xAxis} />

	<g transform="translate({margin.left}, 0)"
	   bind:this={yAxis} />

	<g bind:this={brushp} />
	<g bind:this={brushq} />
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
</style>
