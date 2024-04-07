<script>
  import { onMount } from 'svelte';
  import * as d3 from 'd3';

  export let phase = 0;
  export let id;
  export let data;
  export let invsel;
  export let color = "#CCCCCC";
  let nscolor = "#CCCCCC";
  let width = 0;
  let height = 0;
  let emptydata = true;

  let investor = { 'name': 'Investor', 'value': 0, 'sel': false }
  let noninvestor = { 'name': 'Non-investor', 'value': 1, 'sel': false }

  $: {
	if ($data.length == 0) {
	  investor = { 'name': 'Investor', 'value': 0, 'sel': false };
	  noninvestor = { 'name': 'Non-investor', 'value': 1, 'sel': false };
	  emptydata = true;
	} else {
	  let n = $data.length;
	  let x = ($data.filter(d => d.investor)).length;
	  console.log(`n, x = ${n}, ${x}`);
	  investor.value = x / n;
	  noninvestor.value = (n - x) / n;
	  if (emptydata) {
		investor.sel = true;
		noninvestor.sel = true;
		updateSel();
	  }
	  emptydata = false;
	}
  }
  $: ratios = [investor, noninvestor]

  $: radius = Math.min(width, height) / 2 * 0.9;

  let svg;

  $: arc = d3.arc().innerRadius(0).outerRadius(radius);

  let pie = d3.pie().sort(null).value(d => d.value);
  $: arcs = pie(ratios);

  let arcsg;
  
  function arcTween(a) {
	var i = d3.interpolate(this._current, a);
	this._current = i(0);
	return function(t) {
      return arc(i(t));
	};
  }

  $: {
	let sel = d3.select(arcsg)
		.selectAll('path');
	
	sel.data(arcs)
	  .join("path")
	  .attr("fill", (d) => d.data.sel ? color : nscolor)
	  .attr("opacity", 0.5)
	  .transition()
	  .duration(300)
	  .attrTween('d', arcTween);

	sel.on('click', onClick);
  }

  function onClick(e, d) {
	d.data.sel = !d.data.sel;
	updateSel();
	// This noop assignment triggers Svelte reactivity.
	ratios = ratios;
  }

  $: labelRadius = arc.outerRadius()() * 0.65;

  // A separate arc generator for labels.
  $: label = d3.arc()
  .innerRadius(labelRadius)
  .outerRadius(labelRadius);

  let arcslabel;

  $: d3.select(arcslabel)
  .selectAll("text")
  .data(arcs)
  .join("text")
  .transition()
  .duration(300)
  .attr("transform", d => `translate(${label.centroid(d)})`)
  .select("tspan.pct")
  .text(d => emptydata ? "" : `${(d.data.value * 100).toFixed(0)}%`);

  $: {
	if (phase == 0) {
	  // Do nothing.
	} else if ((phase == 5 || phase == 6) && id == 1) {
	  investor.sel = true;
	  noninvestor.sel = false;
	  updateSel();
	} else if ((phase == 5 || phase == 6) && id == 0) {
	  investor.sel = false;
	  noninvestor.sel = true;
	  updateSel();
	}  else {
	  investor.sel = true;
	  noninvestor.sel = true;
	  updateSel();
	}
  }

  function updateSel(seli, seln) {
	$invsel[0] = investor.sel;
	$invsel[1] = noninvestor.sel;
  }

  onMount(() => {
  });
</script>

<style>
  .container {
	display: flex;
	justify-content: center;
	align-items: center;
	width: 100%;
	height: 100%;
  }

  .arc {
	stroke: white;
	stroke-width: 3px;
  }

  .arclabel {
	text-anchor: middle;
	font-weight: 300;
  }

  .cat {
	font-weight: 400;
  }
</style>

<div class="container" bind:clientWidth={width} bind:clientHeight={height}>
  <svg bind:this={svg} {width} {height} viewBox="{-width / 2}, {-height / 2}, {width}, {height}" style="font-weight: 300;">
	<g bind:this={arcsg} class="arc" />
	<g bind:this={arcslabel} class="arclabel">
	  <text>
		<tspan y="-0.4em" class="cat">Investor</tspan>
		<tspan x="0" y="0.7em" class="pct"></tspan>
	  </text>
	  <text>
		<tspan y="0.7em" class="cat">Non-investor</tspan>
		<tspan x="0" y="-0.4em" class="pct"></tspan>
	  </text>
	</g>
  </svg>
</div>
