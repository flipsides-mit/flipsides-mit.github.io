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

  let progress;
  let index;
  let offset;

  // housing market and investor activity
  let phase = 0;
  let colorp = "#4393C3";
  let colorq = "#F67E4B";
</script>

<!-- <div class="textpage"> -->
  <!--   <div class="section" style="flex: 45; height: 70%; top: 10%; padding-left: 2%;"> -->
	<!-- 	<InvestorActivity {phase} {colorp} {colorq} /> -->
	<!--   </div> -->
  <!--   <div class="section" style="flex: 55; height: 70%; top: 10%; padding-right: 2%;"> -->
	<!-- 	<div class="histograms"> -->
	  <!-- 	  <div class="histpie"> -->
		<!-- 		<div class="pricehist"> -->
		  <!-- 		  <PriceHistogram color={colorp} seldata={seldatap} invsel={invselp} /> -->
		  <!-- 		</div> -->
		<!-- 		<div class="invpie"> -->
		  <!-- 		  <InvestorPie {phase} id={0} color={colorp} data={seldatap} invsel={invselp} /> -->
		  <!-- 		</div> -->
		<!-- 	  </div> -->
	  <!-- 	  <div class="histpie"> -->
		<!-- 		<div class="pricehist"> -->
		  <!-- 		  <PriceHistogram color={colorq} seldata={seldataq} invsel={invselq} /> -->
		  <!-- 		</div> -->
		<!-- 		<div class="invpie"> -->
		  <!-- 		  <InvestorPie {phase} id={1} color={colorq} data={seldataq} invsel={invselq} /> -->
		  <!-- 		</div> -->
		<!-- 	  </div> -->
	  <!-- 	</div> -->
	<!--   </div> -->
  <!-- </div> -->

<div class="flexpagerow" style="width: 100%; height: 100%;">
  <div style="flex: 1;">
	<img width="100%" src="/intro-1.png" alt="act">
  </div>
  <div style="flex: 1; font-size: 40px;">
	In 2023, Massachusetss published the Affordable Homes Acts, introducing the transfer fee to MA for the first time.
  </div>
</div>

<div style="height: 400%; position: relative;">
  <div style="height: 10%;" />
  <div class="flexpage" id="page-payer">
	How should we adjust this policy, for a more equitable distribution of resources?
  </div>
  <div style="height: 10%;" />
  
  <div style="height: 20%; position: sticky; top: 20%;">
	<TaxGroup />
  </div>

  <!-- <div style="height: 100%; position: absolute; top: 0%;"> -->
	<!-- 	<Scroller top="{0.2}" bottom="{0.8}" threshold="{0.2}" bind:index bind:offset bind:progress> -->
	  <!-- 	  <div slot="background"> -->
		<!-- 		<p>index = {index + 1} offset = {offset} progress = {progress}</p> -->
		<!-- 	  </div> -->

	  <!-- 	  <div slot="foreground"> -->
		<!-- 		<section></section> -->
		<!-- 	  </div> -->
	  <!-- 	</Scroller> -->
	<!-- </div> -->
</div>

<div style="height: 100%;" />

<!-- <Scrolly bind:progress --scrolly-viz-width="10000fr" --scrolly-gap="0em"> -->
  <!--   <\!-- Story here -\-> -->
	<!-- 	<div style="height: 800px;"> -->
	  <!-- 	</div> -->
	<!-- 	<svelte:fragment slot="viz"> -->
	  <!-- 	  <\!-- Visualizations here -\-> -->
		<!-- 	  progress = {progress} -->
		<!-- 	  <div class="section" style="flex: 100; height: 400px; top: 20%;"> -->
		  <!-- 		<TaxGroup /> -->
		  <!-- 	  </div> -->
		<!-- 	</svelte:fragment> -->
	<!-- </Scrolly> -->

<style>
  .flexpage {
	display: flex;
	justify-content: center;
	align-items: center;
  }
  .flexpagerow {
	display: flex;
	justify-content: center;
	align-items: center;
	width: 100%;
	height: 100%;
	flex-direction: row;
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
</style>
