<script>
  import { onMount } from 'svelte';
  import { fade } from 'svelte/transition';
  import * as d3 from 'd3';

  let width = 0;
  let height = 0;

  let nhomes;

  const start = 0;
  const end = 2400;

  onMount(() => {
	d3.select(nhomes)
	  .transition()
	  .tween("text", () => {
		const interpolator = d3.interpolateNumber(start, end);
		return function(t) {
		  d3.select(this).text(Math.round(interpolator(t))) 
		}
	  })
	  .duration(3000);
  });

</script>


<div class="container" bind:clientWidth={width} bind:clientHeight={height}>
  <text>
	≈
	<tspan bind:this={nhomes}>2400</tspan>
  </text>
  <text>affordable homes
  </text>
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
  .floating {
	transform:
      rotateX(51deg)
      rotateZ(43deg);
	transform-style: preserve-3d;
	border-radius: 32px;
	box-shadow:
      1px 1px 0 1px #f9f9fb,
      -1px 0 28px 0 rgba(34, 33, 81, 0.01),
      28px 28px 28px 0 rgba(34, 33, 81, 0.25);
	transition:
      .4s ease-in-out transform,
      .4s ease-in-out box-shadow;
  }
  text {
	font: italic 50px sans-serif;
  }
</style>
