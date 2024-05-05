<script>
  import { onMount } from 'svelte';
  import Scrolly from 'svelte-scrolly';
  import Scroller from "@sveltejs/svelte-scroller";
  import TaxGroup from './tax-group.svelte';
  import Revenue from './revenue.svelte';
  // housing market and investor activity
  import InvestorActivity from './investor-activity.svelte';
  import PriceHistogram from './price-histogram.svelte';
  import InvestorPie from './investor-pie.svelte';
  import { seldatap, seldataq, invselp, invselq } from './stores.js';

  let innerHeight;
  let index, offset, progress;

  $: console.log(progress);

  function createTransition(begin, peakb, peake, end) {
	return (progress) => {
	  if (progress < begin) {
		return 0;
	  }
	  if (progress < peakb) {
		return (progress - begin) / (peakb - begin);
	  }
	  if (progress < peake) {
		return 1;
	  }
	  if (progress < end) {
		return 1 - (progress - peake) / (end - peake);
	  }
	  return 0;
	}
  }

  let taxGroupTran = createTransition(20, 50, 70, 90);
  $: alphaBg = 1 - taxGroupTran(progress);
  $: opacityTaxGroup = taxGroupTran(progress);

  // $: {
  // 	if (progress <= 30) {
  // 	  bgalpha = (30 - progress) / 30 * 1;
  // 	} else if (progress <= 70) {
  // 	  bgalpha = 0;
  // 	} else {
  // 	  bgalpha = (progress - 70) / 30 * 1;
  // 	}
  // }

  // color
  let colortim = "#CF1F3F";
  let colorjoe = "#77ABD3";

  // housing market and investor activity
  let phase = 0;
  let colorp = "#4393C3";
  let colorq = "#F67E4B";
</script>

<div style="color: white; background-color: rgb(0 0 0 / {alphaBg});">

  <!-- Intro -->
  <div class="flexpage flex-col">
	<div style="flex: 1; height: 80%;">
	  <img height="100%" src="/intro-1.png" alt="act">
	</div>
	<div style="flex: 1; font-size: 40px; height: 20%; width: 80%;">
	  In 2023, Massachusetts published the Affordable Homes Acts, introducing the <tspan style="color: #EE7733;">transfer fee</tspan> to MA for the first time.
	</div>
  </div>

  <Scrolly bind:progress={progress} threshold={0.9} margin={innerHeight * 0.1} --scrolly-layout="overlap" >
	<!-- Key result: Non-investors paying too much fee -->
	<div class="relpage" style="height: 250vh">
  	  <div style="position: absolute; width: 40%; height: 40%; top: 15%; left: 29%;
				  font-size: 25pt;">
		<center>
		  It seems that the <tspan style="color: {colortim};">middle-class
			majority</tspan>, represented by Tim, are paying a significant amount
		  of transfer fees; <br><br>meanwhile,
		  <tspan style="color: cyan;">investors</tspan> are able to cover their
		  transfer fee expenses through the much higher profits, potentially
		  from flipping houses.
	  </div>
	  <div style="position: absolute; height: 20%; width: 30%; transform: translate(0%, 50%);">
		<img src="/tim-bg.png" style="object-fit: contain;" alt="tim-bg">
	  </div>
	  <div style="position: sticky; float: left; height: 20%; width: 30%; top: 0%; transform: translate(0%, 50%);">
		<img src="/tim.png" style="object-fit: contain;" alt="tim">
	  </div>
	  <div style="position: absolute; height: 20%; width: 30%; transform: translate(230%, 50%);">
		<img src="/joe-bg.png" style="object-fit: contain;" alt="joe-bg">
	  </div>
	  <div style="position: sticky; float: right; height: 20%; width: 30%; top: 0%; transform: translate(0%, 50%);">
		<img src="/joe.png" style="object-fit: contain;" alt="joe">
	  </div>
	</div>

	<!-- Interactive visualization: Tax group breakdown -->
	<div style="height: 300vh;">
	</div>
	<svelte:fragment slot="viz">
	  <div class="text-dark" style="position: relative; height: 80vh; opacity: {opacityTaxGroup};">
		<TaxGroup {colortim} {colorjoe} showtool={false} />
		<!-- <div style="position: absolute; height: 40%; bottom: 10%; left: 12%;"> -->
		  <!--   <img src="/tim.png" style="object-fit: contain;" alt="tim"> -->
		  <!-- </div> -->
		<!-- <div style="position: absolute; height: 40%; bottom: 10%; left: 63%;"> -->
		  <!--   <img src="/joe.png" style="object-fit: contain;" alt="joe"> -->
		  <!-- </div> -->
	  </div>
	</svelte:fragment>
  </Scrolly>

  <!-- Conclusions -->
  <div class="flexpage textbox" style="font-size: 45px;">
	The initial intent of this tool is to present some information more
	openly to the vast group of the middle class, and it is also hoped to
	serve as one of the reference elements for government policy regulation.
  </div>
  <div class="flexpage textbox" style="font-size: 45px;">
  	Balancing the interests of multiple parties is very complex and faces
	many risks. With this tool, we hope that Boston's housing market can
	gradually move towards a more harmonious and fair state.
  </div>

  <div style="height: 50%;" />
</div>

<svelte:window bind:innerHeight />

<style>
  .relpage {
	position: relative;
	width: 100%;
  }
  .flexpage {
	display: flex;
	justify-content: center;
	align-items: center;
	width: 100%;
	height: 100vh;
  }
  .textbox {
	box-sizing: border-box;
	padding: 10%;
  }
  .flex-row {
	flex-direction: row;
  }
  .flex-col {
	flex-direction: column;
  }
  .text-dark {
	color: black;
  }
  #page-payer {
	font-size: 50px;
	width: 100%;
	height: 5%;
	position: sticky;
	top: 0%;
  }
  #page-revenue {
	font-size: 60px;
	width: 100%;
	height: 5%;
	position: sticky;
	top: 0%;
  }
  section {
	height: 480vh;
  }
  img {
    width: 100%;
    height: 100%;
  }
</style>
