<script>
  import { onMount } from 'svelte';
  import { fade } from 'svelte/transition';
  import * as d3 from 'd3';

  let data = [];
  let color = "#F67E4B";
  let width = 0;
  let height = 0;

  $: margin = {
	top: height * 0.25,
	right: width * 0.05,
	bottom: height * 0.25,
	left: width * 0.1,
  };

  $: datap = data.filter(d => d.price <= 1000000);
  $: dataq = data.filter(d => d.price > 1000000);
  $: console.log(`length = ${datap.length} ${dataq.length}`)

  $: binsp = d3.bin()
  .domain([-20, 60])
  // 200 bins
  .thresholds(200)
  .value((d) => d.revenue)(datap);

  $: binsq = d3.bin()
  .domain([-20, 60])
  // 200 bins
  .thresholds(200)
  .value((d) => d.revenue)(dataq);

  $: xScale = d3.scaleLinear()
  .domain([-20, 60])
  .range([margin.left, width - margin.right]);

  $: yScale = d3.scaleLinear()
  .domain([0, d3.max([
	d3.max(binsp, d => d.length),
	d3.max(binsq, d => d.length)])])
  // .domain([0, d3.max(binsp, d => d.length)])
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
  .data(binsp)
  .join("rect")
  .transition()
  .duration(300)
  .attr("x", (d) => xScale(d.x0) + 1)
  .attr("width", (d) => xScale(d.x1) - xScale(d.x0))
  .attr("y", (d) => yScale(d.length))
  .attr("height", (d) => yScale(0) - yScale(d.length))
  .attr("opacity", "0.5");

  $: medianp = d3.median(datap, d => d.revenue);
  $: console.log(medianp)

  $: d3.select(histp)
  .select('line.medianline')
  .transition()
  .duration(300)
  .attr('x1', xScale(medianp))
  .attr('x2', xScale(medianp))
  .attr('y1', medianp ? margin.top : 0)
  .attr('y2', medianp ? height - margin.bottom : 0);

  // $: d3.select(histp)
  // .select('text.mediantext')
  // .transition()
  // .duration(300)
  // .attr('x', xScale(medianp))
  // .attr('y', margin.top)
  // .text(medianp ? `median = ${medianp.toFixed(2)}%` : '');

  let histq;

  $: d3.select(histq)
  .select('g.bars')
  .selectAll('rect')
  .data(binsq)
  .join("rect")
  .transition()
  .duration(300)
  .attr("x", (d) => xScale(d.x0) + 1)
  .attr("width", (d) => xScale(d.x1) - xScale(d.x0))
  .attr("y", (d) => yScale(d.length))
  .attr("height", (d) => yScale(0) - yScale(d.length))
  .attr("opacity", "0.5");

  $: medianq = d3.median(dataq, d => d.revenue);

  $: d3.select(histq)
  .select('line.medianline')
  .transition()
  .duration(300)
  .attr('x1', xScale(medianq))
  .attr('x2', xScale(medianq))
  .attr('y1', medianq ? margin.top : 0)
  .attr('y2', medianq ? height - margin.bottom : 0)

  $: d3.select(histq)
  .select('text.mediantext')
  .transition()
  .duration(300)
  .attr('x', xScale(medianq))
  .attr('y', margin.top)
  .text(medianq ? `median = ${medianq.toFixed(2)}%` : '');

  onMount(async () => {
	data = await d3.csv('/boston-recent.csv', d => { return {
	  ...d,
	  price: +d.price,
	  revenue: +d.revenue,
	  investor: d.investor === 'True',
	  year: +d.year
	}});

	console.log(data)
  });

</script>

<div class="container" bind:clientWidth={width} bind:clientHeight={height}>
  <svg bind:this={svg} width="100%" height="100%" style="font-weight: 300;">
	<g transform="translate(0, {height - margin.bottom})"
	   bind:this={xAxis} />

	<g transform="translate({margin.left}, 0)"
	   bind:this={yAxis} />

	<g bind:this={histp} fill="#BBBBBB" stroke="#BBBBBB">
	  <g class="bars" id="normal" />
	  <line class="medianline" />
	  <text class="mediantext"></text>
	</g>

	<g bind:this={histq} fill={color} stroke={color}>
	  <g class="bars" id="luxury" />
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
  }
  #normal {
	stroke: #BBBBBB;
  }
  #luxury {
	stoke: #F67E4B;
  }
  .bars {
	stroke-opacity: 0.1;
	opacity: 0.5;
  }
  .mediantext {
	transform: translate(3px, -5px) rotate(90deg);
	transform-box: fill-box;
	transform-origin: bottom left;
	font-weight: 300;
	stroke: black;
	opacity: 0.8;
  }
</style>
