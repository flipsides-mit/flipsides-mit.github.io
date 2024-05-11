<script>
  import { onMount } from 'svelte';
  import { fade } from 'svelte/transition';
  import * as d3 from 'd3';
  import { legendColor } from 'd3-svg-legend';

  export let showtool = true;
  export let colortim;
  export let colorjoe;
  // export let sum = 0;
  export let sumInv = 0;
  export let sumNoninv = 0;
  export let noninv = true;
  export let inv = true;
  export let rateNoninv = 0.01;
  export let rateInv = 0.01;
  export let taxThrd = 1000000;
  let dataraw = [];
  let width = 0;
  let height = 0;
  let thrds = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  let miny = 100000000;
  let svg;

  // Margin
  $: margin = {
	top: height * 0.1,
	right: width * 0.05,
	bottom: height * 0.15,
	left: width * 0.1,
  };

  // Computing tax revenue for each transaction
  $: computeTax = (d) => {
	let rate = d.investor ? rateInv : rateNoninv;
	let tax = d.price > taxThrd ? (d.price - taxThrd) * rate : 0;
	if (d.investor && !inv || !d.investor && !noninv) {
	  tax = 0;
	}
	return {
	  price: d.price,
	  investor: d.investor,
	  group: d.group,
	  tax: tax,
	}
  }

  let data = [];
  $: {
	data = dataraw.map(computeTax);
	sumInv = d3.sum(data, d => d.investor ? d.tax : 0);
	sumNoninv = d3.sum(data, d => d.investor ? 0 : d.tax);
	// sum = d3.sum(data, d => d.tax);
	// sum = sumInv + sumNoninv;
	console.log(data);
  }

  let series = [];
  $: {
	let agg = d3.rollup(data, D => d3.sum(D, d => d.tax), d => d.group, d => d.investor);
	series = d3.stack()
	  .keys(d3.union(data.map(d => d.investor)))
	  .value(([, D], key) => D.get(key) ? D.get(key) : 0) // might have empty group
	(agg);
  }
  
  $: console.log(series);

  function toGroup(price) {
	let p = price / 1000000;
	for (let i = thrds.length; i > 0; i--) {
	  if (thrds[i - 1] <= p) {
		return i;
	  }
	}
	return 0;
  }

  let groupNames = [`< ${thrds[0]}`];
  for (let i = 0; i < thrds.length - 1; i++) {
	groupNames.push(`${thrds[i]}-${thrds[i + 1]}`)
  }
  groupNames.push(`> ${thrds[thrds.length - 1]}`)

  // X-scale
  $: xScale = d3.scaleBand()
  .domain(d3.range(0, thrds.length + 1))
  .range([margin.left, width - margin.right])
  .padding(0.2);

  // Y-scale
  $: yScale = d3.scaleLinear()
  .domain([0, d3.max([miny, d3.max(series, d => d3.max(d, d => d[1]))])])
  .rangeRound([height - margin.bottom, margin.top]);

  // Bars
  let barsg;
  $: d3.select(barsg)
  .selectAll("g")
  .data(series)
  .join("g")
  .attr("fill", d => d.key ? colorjoe : colortim)
  .selectAll("rect")
  .data(D => D.map(d => (d.key = D.key, d)))
  .join("rect")
  .attr("x", d => xScale(d.data[0]))
  .attr("width", xScale.bandwidth())
  .transition()
  .duration(300)
  .attr("y", d => yScale(d[1]))
  .attr("height", d => yScale(d[0]) - yScale(d[1]))

  // X-axis
  let xAxis;
  $: {
	let sel = d3.select(xAxis)
		.style('font-family', 'inherit')
		.transition().duration(300)
		.call(d3.axisBottom(xScale).tickSizeOuter(0).tickFormat(d => groupNames[d]));

	// Update the thickness of the axis line
	sel.selectAll('path')
	  .attr('stroke-width', '1px');

	sel.selectAll('.tick > text')
	  .attr('font-size', `${width * 0.02}px`);
  }

  // Y-axis
  let yAxis;
  $: {
	let sel = d3.select(yAxis)
		.style('font-family', 'inherit')
		.transition().duration(300)
		.call(d3.axisLeft(yScale).ticks(5).tickFormat(d => (d / 1000000).toFixed(0)));

	// Update the thickness of the axis line
	sel.selectAll('path')
	  .style('stroke-width', '1px');

	sel.selectAll('.tick > text')
	  .style('font-size', `${width * 0.02}px`);
  }

  // Legend
  let legendg;

  let ordinal = d3.scaleOrdinal()
	  .domain(["non-investor", "investor"])
	  .range([colortim, colorjoe]);

  $: if (legendColor) {
	let legend = legendColor()
		.scale(ordinal);

	d3.select(legendg)
	  .style('font-size', `${width * 0.025}px`)
	  .call(legend);

	d3.select(legendg)
	  .selectAll("rect")
	  .attr("opacity", 0.5);
  }
  
  // Data loading
  onMount(async () => {
	dataraw = await d3.csv('/2022_unfiltered_mapc.csv', d => { return {
	  ...d,
	  price: +d.current_price,
	  investor: d.investor === 'True',
	  group: toGroup(+d.current_price),
	}});
	console.log('Number of data points:', dataraw.length);
  });

</script>

<div class="container" bind:clientWidth={width} bind:clientHeight={height}>  
  <svg bind:this={svg} width="100%" height="100%" style="font-weight: 300;">

	<g bind:this={barsg} class="bars" />

	<g transform="translate(0, {height - margin.bottom})"
	   bind:this={xAxis}>
	  <text class="axislabel"
			x={width - margin.right * 0.7} y={margin.bottom * 0.6}
			style="text-anchor: end; font-size: {width * 0.025}px">
		price range (million $)
	  </text>
	</g>

	<g transform="translate({margin.left}, 0)"
	   bind:this={yAxis}>
	  <text class="axislabel"
			x={-(0.4 * margin.left)} y={margin.top * 0.6}
			style="text-anchor: start; font-size: {width * 0.025}px">
		↑ total transfer fee (million $)
	  </text>
	</g>

	<g bind:this={legendg}
	   transform="translate({margin.left + width * 0.1}, {margin.top * 1})" />
  </svg>
</div>

<style>
  .container {
	display: flex;
	justify-content: center;
	align-items: center;
	width: 100%;
	height: 100%;
	flex-direction: column;
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
  .axislabel {
	fill: currentColor;
	font-size: 20px;
	font-weight: normal;
  }
</style>
