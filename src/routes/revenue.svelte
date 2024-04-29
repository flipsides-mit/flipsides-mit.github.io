<script>
  import { onMount } from 'svelte';
  import { fade } from 'svelte/transition';
  import * as d3 from 'd3';
  import { legendColor } from 'd3-svg-legend';

  let data = [];
  let width = 0;
  let height = 0;

  $: margin = {
	top: height * 0.2,
	right: width * 0.05,
	bottom: height * 0.2,
	left: width * 0.2,
  };

  $: fx = d3.scaleBand()
  .domain(new Set(data.map(d => d.year)))
  .rangeRound([margin.left, width - margin.right])
  .paddingInner(0.1);

  $: xScale = d3.scaleBand()
  .domain(new Set(data.map(d => d.kind)))
  .rangeRound([0, fx.bandwidth()])
  .padding(0.2);

  $: yScale = d3.scaleLinear()
  .domain([0, d3.max(data, d => d.revenue)]).nice()
  .rangeRound([height - margin.bottom, margin.top]);

  let color = {
	residential: "#6699CC",
	commercial: "#DDCC77",
	unclassified: "#44AA99"
  }

  let svg;

  let xAxis;
  $: {
	let sel = d3.select(xAxis)
		.style('font-family', 'inherit')
		.call(d3.axisBottom(fx).tickSizeOuter(0))
	// .call(g => g.selectAll(".domain").remove());

	sel.selectAll('path')
	  .attr('stroke-width', '1px');

	sel.selectAll('.tick > text')
	  .attr('font-size', `${width * 0.025}px`);
  }

  let yAxis;
  $: {
	let sel = d3.select(yAxis)
		.style('font-family', 'inherit')
		.call(d3.axisLeft(yScale).ticks(5, "f"))
	// .call(g => g.selectAll(".domain").remove());

	sel.selectAll('path')
	  .style('stroke-width', '1px');

	sel.selectAll('.tick > text')
	  .style('font-size', `${width * 0.025}px`);
  }

  let bars;
  $: d3.select(bars)
  .selectAll("g")
  .data(d3.group(data.filter(x => x.year != 2022), d => d.year))
  .join("g")
  .attr("transform", ([year]) => `translate(${fx(year)},0)`)
  .selectAll("rect")
  .data(([, d]) => d)
  .join("rect")
  .attr("x", d => xScale(d.kind))
  .attr("width", xScale.bandwidth())
  .attr("y", d => yScale(0))
  .attr("height", 0)
  .attr("y", d => yScale(d.revenue))
  .attr("height", d => yScale(0) - yScale(d.revenue))
  .attr("opacity", 0.5)
  .attr("fill", d => color[d.kind]);

  $: d3.select(bars)
  .selectAll()
  .data(d3.group(data.filter(x => x.year == 2022), d => d.year))
  .join("g")
  .attr("transform", ([year]) => `translate(${fx(year)},0)`)
  .selectAll("rect")
  .data(([, d]) => d)
  .join("rect")
  .attr("x", d => xScale(d.kind))
  .attr("width", xScale.bandwidth())
  .attr("y", d => yScale(0))
  .attr("height", 0)
  .attr("opacity", 0.5)
  .attr("fill", d => color[d.kind])
  .transition()
  .duration(3000)
  .attr("y", d => yScale(d.revenue))
  .attr("height", d => yScale(0) - yScale(d.revenue));

  // Legend
  let legendg;

  let ordinal = d3.scaleOrdinal()
	  .domain(["residential", "commercial", "unclassified"])
	  .range(["#6699CC", "#DDCC77", "#44AA99"]);

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
	data = await d3.csv('/revenue.csv', d => { return {
	  ...d,
	  revenue: +d.revenue / 1000000,
	}});
	data = data.filter(d => d.rate == 0.01)
	console.log('Loaded revenue data: ', data);
  });
</script>

<div class="container" bind:clientWidth={width} bind:clientHeight={height}>
  <svg bind:this={svg} width="100%" height="100%" style="font-weight: 300;">
	<g transform="translate(0, {height - margin.bottom})"
	   bind:this={xAxis}>
	</g>

	<g transform="translate({margin.left}, 0)"
	   bind:this={yAxis}>
	  <text class="axislabel"
			x={-(0.3 * margin.left)} y={margin.top * 0.85}
			style="text-anchor: start; font-size: {width * 0.025}px">
		↑ revenue (million $)
	  </text>
	</g>

	<g bind:this={bars} />

	<g bind:this={legendg}
	   transform="translate({margin.left + width * 0.6}, {margin.top * 0.8})" />
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
  .axislabel {
	fill: currentColor;
	font-size: 20px;
	font-weight: normal;
  }
  svg {
	color: white;
  }
</style>
