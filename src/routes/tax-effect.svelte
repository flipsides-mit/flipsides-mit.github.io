<script>
  import { onMount } from 'svelte';
  import { fade } from 'svelte/transition';
  import * as d3 from 'd3';
  import { sliderBottom } from 'd3-simple-slider';
  import { legendColor } from 'd3-svg-legend';

  let dataraw = [];
  let color = "#F67E4B";
  let width = 0;
  let height = 0;
  let taxrate = 0.01;
  let flipped = false;
  let investor = true;

  $: margin = {
	top: height * 0.05,
	right: width * 0.05,
	bottom: height * 0.15,
	left: width * 0.1,
  };

  $: xrange = flipped ? [-20, 150] : [-20, 60];

  $: toProfit = (d) => {
	let diff = d.current_price - d.previous_price;
	let tax = d.current_price > 1000000 ? (d.current_price - 1000000) * taxrate : 0;
	let taxed = diff - tax;
	let profit = taxed / d.previous_price / d.year_diff * 100;
	return {
	  price: d.current_price,
	  profit: profit,
	  year: d.year_diff,
	  investor: d.investor,
	}
  }

  let data = [];
  $: {
	data = dataraw.map(toProfit);
	if (investor) {
	  data = data.filter(d => d.investor)
	}
	if (flipped) {
	  data = data.filter(d => d.year <= 2);
	}
  }

  $: datap = data.filter(d => d.price <= 1000000);
  $: dataq = data.filter(d => d.price > 1000000);

  $: console.log(`length = ${datap.length} ${dataq.length}`)

  $: binsp = d3.bin()
  .domain(xrange)
  // 200 bins
  .thresholds(200)
  .value((d) => d.profit)(datap);

  $: binsq = d3.bin()
  .domain(xrange)
  // 200 bins
  .thresholds(200)
  .value((d) => d.profit)(dataq);

  $: xScale = d3.scaleLinear()
  .domain(xrange)
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

  $: medianp = d3.median(datap, d => d.profit);
  $: console.log(medianp)

  $: d3.select(histp)
  .select('line.medianline')
  .transition()
  .duration(300)
  .attr('x1', xScale(medianp))
  .attr('x2', xScale(medianp))
  .attr('y1', medianp ? margin.top : 0)
  .attr('y2', medianp ? height - margin.bottom : 0);

  $: d3.select(histp)
  .select('text.mediantext')
  .transition()
  .duration(300)
  .attr('x', xScale(medianp))
  .attr('y', margin.top)
  .text(medianp ? `median = ${medianp.toFixed(2)}%` : '');

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

  $: medianq = d3.median(dataq, d => d.profit);

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

  let sliderg;

  let rates = [0, 0.01, 0.02, 0.03, 0.05, 0.1];

  let slider;
  $: if (sliderBottom) {
	slider = sliderBottom()
	  .min(d3.min(rates))
	  .max(d3.max(rates))
	  .width(width * 0.35)
	// .tickFormat("%f")
	  .tickValues(rates)
	  .on("onchange", (d, e) => taxrate = d);

	d3.select(sliderg)
	  .call(slider);

	d3.select(sliderg)
	  .selectAll("text")
	  .attr("font-size", "12px");
  }

  // Legend
  let legendg;

  let ordinal = d3.scaleOrdinal()
	  .domain(["<= 1 million $", "> 1 million $"])
	  .range(["#BBBBBB", "#F67E4B"]);

  $: if (legendColor) {
	let legend = legendColor()
		.scale(ordinal);

	d3.select(legendg)
	  .call(legend);

	d3.select(legendg)
	  .selectAll("rect")
	  .attr("opacity", 0.5);
  }

  onMount(async () => {
	dataraw = await d3.csv('/2022_mapc.csv', d => { return {
	  ...d,
	  current_price: +d.current_price,
	  previous_price: +d.previous_price,
	  investor: d.investor === 'True',
	  year_diff: +d.year_diff
	}});

	// dataraw = dataraw.filter(d => d.year_diff <= 2);

	console.log('Number of data points:', dataraw.length);
  });
</script>

<div class="container" bind:clientWidth={width} bind:clientHeight={height}>
  <div style="position: relative; bottom: 5%;">
	<label style="position: relative; right: 10%;">
	  <input type="checkbox" bind:checked={investor} />
	  Show investor transactions only
	</label>
	<label style="position: relative; left: 10%;">
	  <input type="checkbox" bind:checked={flipped} />
	  Show flipped transactions only
	</label>
  </div>
  <svg bind:this={svg} width="100%" height="100%" style="font-weight: 300;">
	<g transform="translate(0, {height - margin.bottom})"
	   bind:this={xAxis}>
	  <text class="axislabel"
			x={width - margin.right * 0.7} y={margin.bottom * 0.5}
			style="text-anchor: end; font-size: {width * 0.03}px">
		profit per year (%) →
	  </text>
	</g>

	<g transform="translate({margin.left}, 0)"
	   bind:this={yAxis}>
	  <text class="axislabel"
			x={-(0.4 * margin.left)} y={margin.top * 0.6}
			style="text-anchor: start; font-size: {width * 0.03}px">
		↑ # transactions
	  </text>
	</g>

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

	<g bind:this={sliderg}
	   class="slider"
	   transform="translate({margin.left + width * 0.5}, {margin.top / 2})" />

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
  .slider {	
  }
  .axislabel {
	fill: currentColor;
	font-size: 20px;
	font-weight: normal;
  }
</style>
