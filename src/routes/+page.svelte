<script>
  import { onMount } from 'svelte';
  import { fade, fly } from 'svelte/transition';
  import InvestorActivity from './investor-activity.svelte';
  import PriceHistogram from './price-histogram.svelte';
  import InvestorPie from './investor-pie.svelte';
  import Revenue from './revenue.svelte';
  import Affordable from './affordable.svelte';
  // import TaxRate from './tax-rate.svelte';
  import TaxEffect from './tax-effect.svelte';
  import TaxGroup from './tax-group.svelte';
  import { seldatap, seldataq, invselp, invselq } from './stores.js';
  
  let flipped = false;
  let curframe = 5;
  let phase = 0;
  let colorp = "#4393C3";
  let colorq = "#F67E4B";
  let icollage = 1;
  let curfinding = 0;

  function toggleFlip() {
    flipped = !flipped;
  }

  function toFrame(n) {
    return () => {
	  curframe = n;
	}
  }

  function forward() {
	if (curframe < 5) {
	  curframe = curframe + 1
	  phase = 0;
	}
  }

  function back() {
	if (curframe > 1) {
	  curframe = curframe - 1
	  phase = 0;
	}
  }

  function next() {
	if (curframe == 1) {
	  if (phase < 6) {
		phase = phase + 1;
	  }
	} else if (curframe == 3) {
	  if (phase < 1) {
		phase = phase + 1
	  }
	}
  }

  function prev() {
	if (phase > 0) {
	  phase = phase - 1;
	}
  }

  function toggleTransfer() {
	transfer = !transfer;
  }

  function setIntroCollage(n) {
	icollage = n;
  }

  function handleKeydown(event) {
	if (event.keyCode === 37) {
      // Left key pressed
      back();
    } else if (event.keyCode === 38) {
      // Up key pressed
	  prev();
    } else if (event.keyCode === 39) {
      // Right key pressed
      forward();
    } else if (event.keyCode === 40) {
      // Down key pressed
      next();
    }
  }

  function animateIntroCollage() {
	let n = 5000;
	setTimeout(() => setIntroCollage(2), 1 * n);
	setTimeout(() => setIntroCollage(3), 2 * n);
	setTimeout(() => setIntroCollage(4), 3 * n);
	setTimeout(() => {
	  setIntroCollage(5);
	  flipped = true;
	}, 4 * n);
	setTimeout(() => setIntroCollage(6), 5 * n);
	setTimeout(() => setIntroCollage(7), 6 * n);
	setTimeout(() => setIntroCollage(8), 7 * n);
  }

  onMount(() => {
	animateIntroCollage()
  })
</script>

<style>
  .container {
    perspective: 1000px;
    width: 100%;
    height: 100%;
	/* display: flex; */
	/* align-items: center; */
	/* justify-content: center; */
	position: relative;
  }

  .title {
	position: fixed;
	top: 0;
	left: 0;
	font-size: 250%;
	font-weight: bold;
	stroke: black;
	/* background: #F7F7F7; */
	/* box-shadow: 0 5px 15px rgba(0,0,0,0.3); */
  }

  .card {
    width: 50%;
    height: 180px;
    transition: transform 0.6s;
    transform-style: preserve-3d;
    cursor: pointer;
    position: relative;
	display: flex;
	align-items: center;
	justify-content: center;
  }

  .face {
    position: absolute;
    width: 80%;
    height: 80%;
    backface-visibility: hidden;
    display: flex;
    align-items: center;
    justify-content: center;
    color: black;
    font-size: 20px;
	border-radius: 20px;
	padding: 25px;
  }

  .prev, .next, .transfer {
	position: absolute;
	cursor: pointer;
	font-size: 20px;
	color: black;
	background: #F7F7F7;
	padding: 5pt;
	z-index: 5;
  }

  .prev {
	bottom: 15px;
	left: 15px;
  }

  .next {
	bottom: 15px;
	right: 15px;
  }

  .front {
    background: #D9F0D3;
  }

  .back {
    background: #FEDA8B;
    transform: rotateY(180deg);
  }

  .front, .back, .next, .prev, .transfer {
	box-shadow: 0 5px 15px rgba(0,0,0,0.3);
  }

  @keyframes shaking {
	0% { transform: rotateY(0deg); }
	25% { transform: rotateY(1deg); }
	50% { transform: rotateY(0eg); }
	75% { transform: rotateY(-1deg); }
	100% { transform: rotateY(0deg); }
  }

  .front:hover {
    animation: shaking 0.3s ease-in-out both infinite;
  }

  .section {
	width: 50%;
	height: 100%;
	display: flex;
	align-items: center;
	flex-direction: column;
	justify-content: center;
	position: relative;
  }

  .desp {
    width: 80%;
    height: 120px;
	position: relative;
    transition: transform 0.6s;
    transform-style: preserve-3d;
    cursor: pointer;
	display: flex;
	align-items: center;
	justify-content: center;
	background: #F7F7F7;
	color: black;
    font-size: 20px;
	border-radius: 20px;
	padding: 25px;
  }

  .histograms {
	width: 100%;
	height: 100%;
	position: relative;
	display: flex;
	align-items: center;
	justify-content: center;
	flex-direction: column;
  }

  .histpie {
	width: 100%;
	height: 45%;
	display: flex;
	align-items: center;
	justify-content: center;
  }

  .flexpage {
	width: 100%;
	height: 100%;
	display: flex;
	align-items: center;
	justify-content: center;
  }

  .placeholder {
    width: 80%;
    height: 120px;
	position: relative;
	display: flex;
	align-items: center;
	justify-content: center;
	border: solid 1pt;
	color: black;
    font-size: 20px;
	padding: 25px;
  }

  #redistribute {
	height: 250pt;
	top: 100pt;
  }

  .transfer {
	top: 90%;
	left: 50%;
	transform: translate(-50%, -50%);
  }

  .collage-container {
	width: 45%;
	height: 100%;
	display: flex;
	align-items: center;
  }

  .collage {
	position: absolute;
  }

  .items {
	font-size: 30px;
  }

  #findings {
	top: 10%;
	position: absolute;
	font-size: 20px;
  }

  .pricehist {
	width: 100%;
	height: 100%;
	flex: 70;
  }

  .invpie {
	width: 100%;
	height: 100%;
	flex: 30;
  }

  .annotation {
	position: absolute;
	font-size: 200%;
  }

  .slides {
	position: relative;
	height: 100%;
	width: 90%;
	display: flex;
	justify-content: center;
	font-size: 200%;
	padding-left: 10%;
	flex-direction: column;
  }
</style>

<div class="container">
  {#if curframe == 1}
	<div class="title">
	  Overall Housing Market and Investor Activity
	</div>
	<!-- <div class="prev" on:click={back}>←</div> -->
	<div class="next" on:click={forward}>→</div>
	<text class="annotation"
		  style="width: 90%; top: 8%; margin-left: 5%; margin-right: 5%; display: {1 <= phase ? "inline" : "none"};">
	  <tspan style="font-weight: bold;">Finding 1:</tspan>
	  <tspan >
		More investors in the high-end housing markets.
	  </tspan>
	</text>
	<text class="annotation" style="width: 90%; top: 15%; margin-left: 5%; margin-right: 5%;">
	  <tspan style="font-weight: bold; display: {phase >= 4 ? "inline" : "none"};">Finding 2:</tspan>
	  <tspan style="display: {phase >= 4 ? "inline" : "none"};">
		Properties that are flipped make a significant amount of profit,
	  </tspan>
	  <tspan style="display: {phase >= 5 ? "inline" : "none"};">
		especially for investors,
	  </tspan>
	  <tspan style="display: {phase >= 6 ? "inline" : "none"};">
		and even more so in the high-end housing markets.
	  </tspan>
	</text>
	<div class="flexpage">
	  <div class="section" style="flex: 45; height: 70%; top: 10%; padding-left: 2%;">
		<InvestorActivity {phase} {colorp} {colorq} />
	  </div>
	  <div class="section" style="flex: 55; height: 70%; top: 10%; padding-right: 2%;">
		<div class="histograms">
		  <div class="histpie">
			<div class="pricehist">
			  <PriceHistogram color={colorp} seldata={seldatap} invsel={invselp} />
			</div>
			<div class="invpie">
			  <InvestorPie {phase} id={0} color={colorp} data={seldatap} invsel={invselp} />
			</div>
		  </div>
		  <div class="histpie">
			<div class="pricehist">
			  <PriceHistogram color={colorq} seldata={seldataq} invsel={invselq} />
			</div>
			<div class="invpie">
			  <InvestorPie {phase} id={1} color={colorq} data={seldataq} invsel={invselq} />
			</div>
		  </div>
		</div>
	  </div>
	</div>
  {/if}
  {#if curframe == 2}
	<div class="title">
	  Benefit of the Affordable Homes Act
	</div>
	<div class="flexpage">
	  <div class="section" style="flex: 50; height: 80%; top: 5%;">
		<Revenue />
	  </div>
	  <div class="section" style="flex: 50; height: 80%; top: 5%;">
		<Affordable />
	  </div>
	</div>

  	<div class="prev" on:click={back}>←</div>
	<div class="next" on:click={forward}>→</div>
  {/if}
  {#if curframe == 3}
	<div class="title">
	  Profit Affected by Transfer Fee and Investor Redistribution
	</div>
	<div class="flexpage">
	  <div class="section" style="flex: 50; height: 80%; top: 5%;">
		<TaxEffect />
	  </div>
	  <div class="section"
		   style="flex: 50; height: 80%; top: 5%;">
		<img
		  style="display: {phase > 0 ? "initial" : "none"};"
		  width="100%" src="/potential-buyer.png" alt="potential buyers">
	  </div>
	</div>
  	<div class="prev" on:click={back}>←</div>
	<div class="next" on:click={forward}>→</div>
  {/if}
  {#if curframe == 4}
	<div class="slides">
	  <text style="font-weight: bold; font-size: 120%;">Next Step
	  </text>
	  <ul>
		<li>More complex models like <a href="https://en.wikipedia.org/wiki/Ordinary_least_squares">OLS</a></li>
		<li>Demand and supply curve</li>
	  </ul>
	  <text style="font-weight: bold; font-size: 120%;">Takeaways
	  </text>
	  <ul>
		<li>The tax rate of Mass is relatively conservative</li>
		<li>Limited impacts to the low-priced market</li>
		<li>Limited aid to the <a href="https://www.wcvb.com/article/more-than-42k-families-waiting-for-massachusetts-housing-how-much-it-would-cost-to-house-them/45702471">42000 families</a> who need an affordable home</li>
	  </ul>
	</div>
  	<div class="prev" on:click={back}>←</div>
  {/if}
  {#if curframe == 5}
	<div class="flexpage">
	  <div class="section"
		   style="flex: 0; height: 80%; top: 5%;">
	  </div>
	  <div class="section" style="flex: 100; height: 80%; top: 5%;">
		<TaxGroup />
	  </div>
	</div>

  {/if}
</div>

<svelte:window
  on:keydown={handleKeydown}
/>
