<script>
  import { onMount } from 'svelte';
  import { fade } from 'svelte/transition';
  import * as d3 from 'd3';
  import { sliderBottom } from 'd3-simple-slider';
  import { legendColor } from 'd3-svg-legend';

  export let sepTax = false;
  export let noninv = true;
  export let inv = true;
  export let rateNoninv = 0.01;
  export let rateInv = 0.01;
  export let taxThrd = 1000000;
  let rateBoth = 0.01;
  let width = 0;
  let height = 0;

  let miny = 100000000;
  let svg;

  // Margin
  $: margin = {
	top: height * 0.1,
	right: width * 0.1,
	bottom: height * 0.15,
	left: width * 0.1,
  };

  // Rate slider
  let ratenig;
  let rateig;
  let ratebothg;
  let exemptiong;
  let rates = [0, 0.01, 0.02, 0.03, 0.05, 0.1];
  let exempts = [1, 2, 3, 5, 10].map(d => d * 1000000);
  let sliderni;
  let slideri;
  let sliderboth;
  let slidere;
  
  // Data loading
  onMount(async () => {
	// setup sliders
	let textRatioSlider = 0.03;

	// rate slider for both investors and non-investors
	sliderboth = sliderBottom()
	  .min(d3.min(rates))
	  .max(d3.max(rates))
	  .width(width * 0.8)
	  .tickFormat(d => `${(d * 100).toFixed(1)}%`)
	  .tickValues(rates)
	  .value(rateBoth)
	  .on("onchange", (d, e) => {
		rateNoninv = d;
		rateInv = d;
	  });
	
	d3.select(ratebothg)
	  .call(sliderboth);

	d3.select(ratebothg)
	  .selectAll("text")
	  .attr("font-size", `${width * textRatioSlider}px`);

	// non-investor rate slider
	sliderni = sliderBottom()
	  .min(d3.min(rates))
	  .max(d3.max(rates))
	  .width(width * 0.8)
	  .tickFormat(d => `${(d * 100).toFixed(1)}%`)
	  .tickValues(rates)
	  .value(rateNoninv)
	  .on("onchange", (d, e) => rateNoninv = d);
	
	d3.select(ratenig)
	  .call(sliderni);

	d3.select(ratenig)
	  .selectAll("text")
	  .attr("font-size", `${width * textRatioSlider}px`);

	// investor rate slider
	slideri = sliderBottom()
	  .min(d3.min(rates))
	  .max(d3.max(rates))
	  .width(width * 0.8)
	  .tickFormat(d => `${(d * 100).toFixed(1)}%`)
	  .tickValues(rates)
	  .value(rateInv)
	  .on("onchange", (d, e) => rateInv = d);

	d3.select(rateig)
	  .call(slideri);

	d3.select(rateig)
	  .selectAll("text")
	  .attr("font-size", `${width * textRatioSlider}px`);

	slidere = sliderBottom()
	  .min(d3.min(exempts))
	  .max(d3.max(exempts))
	  .width(width * 0.8)
	  .tickFormat(d => `${(d / 1000000).toFixed(1)}M$`)
	  .tickValues(exempts)
	  .value(rateInv)
	  .on("onchange", (d, e) => taxThrd = d);

	d3.select(exemptiong)
	  .call(slidere);

	d3.select(exemptiong)
	  .selectAll("text")
	  .attr("font-size", `${width * textRatioSlider}px`);
  });

</script>

<div class="container" bind:clientWidth={width} bind:clientHeight={height}>
  <label style="position: absolute; top: 5%; left: 8%; font-size: {width * 0.05}px;">
	<input type="checkbox" bind:checked={noninv} />
	show non-investor transactions
  </label>
  <label style="position: absolute; top: 15%; left: 8%; font-size: {width * 0.05}px;">
	<input type="checkbox" bind:checked={inv} />
	show investor transactions
  </label>
  
  <svg bind:this={svg} width="100%" height="100%" style="font-weight: 300;">
	<g bind:this={exemptiong}
	   class="slider"
	   transform="translate({margin.left}, {margin.top / 2 + 0.3 * height})">
	  <text
		x="{-0.01 * width}px" y="{-(0.02 * height)}px"
		text-anchor="center"
		style="font-size: {width * 0.05}px;">
		exemption threshold
	  </text>
	</g>

	<g bind:this={ratebothg}
	   class="slider"
	   transform="translate({margin.left}, {margin.top / 2 + 0.55 * height})"
	   display="{sepTax ? 'default' : 'none'}">
	  <text
		x="{-0.01 * width}px" y="{-(0.02 * height)}px"
		text-anchor="center"
		style="font-size: {width * 0.05}px;">
		tax rate
	  </text>
	</g>

	<g bind:this={ratenig}
	   class="slider"
	   transform="translate({margin.left}, {margin.top / 2 + 0.55 * height})"
	   display="{sepTax ? 'none' : 'default'}">
	  <text
		x="{-0.01 * width}px" y="{-(0.02 * height)}px"
		text-anchor="center"
		style="font-size: {width * 0.05}px;">
		tax rate (non-investor)
	  </text>
	</g>

	<g bind:this={rateig}
	   class="slider"
	   transform="translate({margin.left}, {margin.top / 2 + 0.80 * height})"
	   display="{sepTax ? 'none' : 'default'}">
	  <text
		x="{-0.01 * width}px" y="{-(0.02 * height)}px"
		text-anchor="center"
		style="font-size: {width * 0.05}px;">
		tax rate (investor)
	  </text>
	</g>

	<!-- <text -->
	<!--   x="{0.35 * width}px" -->
	<!--   y="{0.3 * height}px" -->
	<!--   style="font-size: {width * 0.025}px;"> -->
	<!--   Total revenue: ${(sum / 1000000).toFixed(0)} M -->
	<!-- </text> -->
  </svg>
</div>

<style>
  .container {
	position: relative;
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
