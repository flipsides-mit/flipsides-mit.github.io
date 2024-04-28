<script>
  import { onMount } from 'svelte';
  import { fade } from 'svelte/transition';
  import * as d3 from 'd3';
  import { sliderBottom } from 'd3-simple-slider';
  import { legendColor } from 'd3-svg-legend';

  let dataraw = [];
  let width = 0;
  let height = 0;
  let taxrate = 0.01;
  let taxthrd = 1000000;
  let noninv = true;
  let inv = true;
  let colorinv = '#6699CC';
  let colornoninv = '#DDCC77';

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
	let tax = d.price > taxthrd ? (d.price - taxthrd) * taxrate : 0;
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
	console.log(data);
  }

  $: series = d3.stack()
  .keys(d3.union(data.map(d => d.investor)))
  .value(([, D], key) => D.get(key))
  (d3.rollup(data, D => d3.sum(D, d => d.tax), d => d.group, d => d.investor));
  
  $: console.log(series);

  // X-scale
  $: xScale = d3.scaleBand()
  .domain(["cheap", "luxury"])
  .range([margin.left, width - margin.right])
  .padding(0.8);

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
  .attr("fill", d => d.key ? colorinv : colornoninv)
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
		.call(d3.axisBottom(xScale).tickSizeOuter(0));

	// Update the thickness of the axis line
	sel.selectAll('path')
	  .attr('stroke-width', '1px');

	sel.selectAll('.tick > text')
	  .attr('font-size', `${width * 0.025}px`);
  }

  // Y-axis
  let yAxis;
  $: {
	let sel = d3.select(yAxis)
		.style('font-family', 'inherit')
		.transition().duration(300)
		.call(d3.axisLeft(yScale).ticks(5).tickFormat((d, i) => (d / 1000000).toFixed(0)));

	// Update the thickness of the axis line
	sel.selectAll('path')
	  .style('stroke-width', '1px');

	sel.selectAll('.tick > text')
	  .style('font-size', `${width * 0.025}px`);
  }

  // Rate slider
  let sliderg;
  let rates = [0, 0.01, 0.02, 0.03, 0.05, 0.1];
  let slider;

  $: if (sliderBottom) {
	slider = sliderBottom()
	  .min(d3.min(rates))
	  .max(d3.max(rates))
	  .width(width * 0.35)
	  .tickFormat(d => `${(d * 100).toFixed(1)} %`)
	  .tickValues(rates)
	  .on("onchange", (d, e) => taxrate = d);

	d3.select(sliderg)
	  .call(slider);

	d3.select(sliderg)
	  .selectAll("text")
	  .attr("font-size", `${width * 0.013}px`);
  }

  // Legend
  let legendg;

  let ordinal = d3.scaleOrdinal()
	  .domain(["non-investor", "investor"])
	  .range([colornoninv, colorinv]);

  $: if (legendColor) {
	let legend = legendColor()
		.scale(ordinal);

	d3.select(legendg)
	  .call(legend);

	d3.select(legendg)
	  .selectAll("rect")
	  .attr("opacity", 0.5);
  }
  
  // Data loading
  onMount(async () => {
	dataraw = await d3.csv('/2022_mapc.csv', d => { return {
	  ...d,
	  price: +d.current_price,
	  investor: d.investor === 'True',
	  group: +d.current_price < 2000000 ? 'cheap' : 'luxury',
	}});
	console.log('Number of data points:', dataraw.length);
  });

</script>

<div class="container" bind:clientWidth={width} bind:clientHeight={height}>
  <div style="position: relative; bottom: 5%;">
	<label style="position: relative; right: 10%;">
	  <input type="checkbox" bind:checked={noninv} />
	  Show non-investor transactions
	</label>
	<label style="position: relative; left: 10%;">
	  <input type="checkbox" bind:checked={inv} />
	  Show investor transactions
	</label>
  </div>
  <svg bind:this={svg} width="100%" height="100%" style="font-weight: 300;">

	<g bind:this={barsg} class="bars" />

	<g transform="translate(0, {height - margin.bottom})"
	   bind:this={xAxis}>
	  <text class="axislabel"
			x={width - margin.right * 0.7} y={margin.bottom * 0.5}
			style="text-anchor: end; font-size: {width * 0.025}px">
		profit per year (%) →
	  </text>
	</g>

	<g transform="translate({margin.left}, 0)"
	   bind:this={yAxis}>
	  <text class="axislabel"
			x={-(0.4 * margin.left)} y={margin.top * 0.6}
			style="text-anchor: start; font-size: {width * 0.025}px">
		↑ # transactions
	  </text>
	</g>

	<g bind:this={sliderg}
	   class="slider"
	   transform="translate({margin.left + width * 0.5}, {margin.top / 2})">
	  <text
		x="{-0.01 * width}px" y="{-(0.02 * height)}px"
		text-anchor="center"
		style="font-size: {width * 0.02}px;">
		tax rate
	  </text>
	</g>

	<g bind:this={legendg}
	   transform="translate({margin.left + width * 0.69}, {margin.top * 2.5})" />
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
  .slider {	
  }
  .axislabel {
	fill: currentColor;
	font-size: 20px;
	font-weight: normal;
  }
</style>