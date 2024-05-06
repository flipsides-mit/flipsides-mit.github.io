<script>
  import { onMount } from 'svelte';
  import { fade } from 'svelte/transition';
  import * as d3 from 'd3';
  // import { seldatap, seldataq } from './stores.js';

  export let color = "steelblue";
  export let seldata;
  export let invsel;
  let width = 0;
  let height = 0;

  $: margin = {
	top: height * 0.18,
	right: width * 0.05,
	bottom: height * 0.18,
	left: width * 0.1,
  };

  let datainv = [];
  $: {
	datainv = $seldata;
	if (!$invsel[0]) {
	  datainv = datainv.filter(x => x.investor == false);
	}
	if (!$invsel[1]) {
	  datainv = datainv.filter(x => x.investor == true);
	}
	console.log('invsel = ', $invsel)
  }

  $: xrange = 50 < medianp ? [-20, medianp * 1.5] : [-20, 60];

  $: bins = d3.bin()
  .domain(xrange)
  // 200 bins
  .thresholds(200)
  .value((d) => d.profit)(datainv);

  $: xScale = d3.scaleLinear()
  .domain([bins[0].x0, bins[bins.length - 1].x1])
  .range([margin.left, width - margin.right]);

  $: yScale = d3.scaleLinear()
  .domain([0, d3.max(bins, (d) => d.length)])
  .range([height - margin.bottom, margin.top]);

  let xAxis;
  let yAxis;

  $: {
	let sel = d3.select(xAxis)
		.style('font-family', 'inherit')
		.transition().duration(300)
		.call(d3.axisBottom(xScale).ticks(5).tickSizeOuter(0));

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
		.call(d3.axisLeft(yScale).ticks(5));

	// Update the thickness of the axis line
	sel.selectAll('path')
	  .style('stroke-width', '1px');

	sel.selectAll('.tick > text')
	  .style('font-size', `${width * 0.025}px`);
  }

  let svg;

  let histp;

  $: d3.select(histp)
  .select('g.bars')
  .selectAll('rect')
  .data(bins)
  .join("rect")
  .transition()
  .duration(300)
  .attr("x", (d) => xScale(d.x0) + 1)
  .attr("width", (d) => xScale(d.x1) - xScale(d.x0))
  .attr("y", (d) => yScale(d.length))
  .attr("height", (d) => yScale(0) - yScale(d.length))
  .attr("opacity", "0.5");

  $: medianp = d3.median(datainv, d => d.profit);

  $: d3.select(histp)
  .select('line.medianline')
  .transition()
  .duration(300)
  .attr('x1', xScale(medianp))
  .attr('x2', xScale(medianp))
  .attr('y1', medianp ? margin.top : 0)
  .attr('y2', medianp ? height - margin.bottom : 0)

  $: d3.select(histp)
  .select('text.mediantext')
  .style('stroke', 'black')
  .style('fill', 'black')
  .style('font-size', `${width * 0.03}px`)
  .transition()
  .duration(300)
  .attr('x', xScale(medianp))
  .attr('y', margin.top)
  .text(medianp ? `median = ${medianp.toFixed(2)}%` : '');

</script>

<div class="container" bind:clientWidth={width} bind:clientHeight={height}>
  <svg bind:this={svg} width="100%" height="100%" style="font-weight: 300;">
	<g transform="translate(0, {height - margin.bottom})"
	   bind:this={xAxis}>
	  <text class="axislabel"
			x={width} y={margin.bottom * 0.8}
			style="text-anchor: end; font-size: {width * 0.03}px">
		profit per year (%) →
	  </text>
	</g>

	<g transform="translate({margin.left}, 0)"
	   bind:this={yAxis}>
	  <text class="axislabel"
			x={-(0.5 * margin.left)} y={margin.top * 0.8}
			style="text-anchor: start; font-size: {width * 0.03}px">
		↑ # transactions
	  </text>
	</g>

	<g bind:this={histp} fill={color} stroke={color}>
	  <g class="bars" />
	  <line class="medianline" />
	  <text class="mediantext"></text>
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
  .medianline {
	stroke-width: 1px;
	stroke-dasharray: 3, 1;
	stroke-opacity: 0.8;
	stroke-width: 2px;
	stroke: black;
  }
  .bars {
	stroke-opacity: 0.1;
  }
  .mediantext {
	transform: translate(3px, -5px) rotate(90deg);
	transform-box: fill-box;
	transform-origin: bottom left;
	font-weight: 300;
	stroke: white;
	opacity: 0.8;
  }
  .axislabel {
	fill: currentColor;
	font-size: 20px;
	font-weight: normal;
  }
</style>
