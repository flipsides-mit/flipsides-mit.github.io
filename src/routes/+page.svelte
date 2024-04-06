<script>
  import { onMount } from 'svelte';
  import { fade, fly } from 'svelte/transition';
  import InvestorActivity from './investor-activity.svelte';
  import PriceHistogram from './price-histogram.svelte';
  import InvestorPie from './investor-pie.svelte';
  import Revenue from './revenue.svelte';
  import Affordable from './affordable.svelte';
  import TaxRate from './tax-rate.svelte';
  import { seldatap, seldataq, invselp, invselq } from './stores.js';
  
  let flipped = false;
  let curframe = 1;
  let transfer = false;
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
	}
  }

  function back() {
	if (curframe > 1) {
	  curframe = curframe - 1
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
    } else if (event.keyCode === 39) {
      // Right key pressed
      forward();
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
    height: 98%;
	display: flex;
	align-items: center;
	justify-content: center;
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
	align-self: flex-end;
	cursor: pointer;
	font-size: 20px;
	color: black;
	background: #F7F7F7;
	padding: 5pt;
	z-index: 5;
  }

  .prev {
	left: 25px;
  }

  .next {
	right: 25px;
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
	position: relative;
	padding-top: 50px;
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
	height: 70%;
	position: absolute;
	top: 20%;
	display: flex;
	align-items: center;
	justify-content: center;
	flex-direction: column;
  }

  .histpie {
	width: 100%;
	height: 50%;
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
</style>

<div class="container">
  {#if curframe == 1}
	<div class="card" style="transform: rotateY({flipped ? 180 : 0}deg);" on:click={toggleFlip}>
	  <div class="face front">Collecting transfer fee is a reasonable action to
		achieve better housing affordability. For instance, the government can use the
		collected tax to build more affordable housing. Furthermore, transfer fee also
		has the potential of inhibiting investor activity in the housing market.</div>
	  <div class="face back">On the flip side, applying transfer fee might also
		have some unintended side-effects. Specifically, a decrease in the profit of
		luxury housing market may prompt investors to reallocate their resources from
		the luxury housing market to other lower-end housing markets.</div>
	</div>
	<div class="collage-container">
	  {#if icollage == 1}
		<div class="collage" out:fade={{ duration: 300 }} in:fade={{ duration: 300 }}>
		  <img src="/intro-1.png" width="100%" alt="Intro">
		</div>
	  {/if}
	  {#if icollage == 2}
		<div class="collage" out:fade={{ duration: 300 }} in:fade={{ duration: 300 }}>
		  <img src="/intro-2.png" width="100%" alt="Intro">
		</div>
	  {/if}
	  {#if icollage == 3}
		<div class="collage" out:fade={{ duration: 300 }} in:fade={{ duration: 300 }}>
		  <img src="/intro-3.png" width="100%" alt="Intro">
		</div>
	  {/if}
	  {#if icollage == 4}
		<div class="collage" out:fade={{ duration: 300 }} in:fade={{ duration: 300 }}>
		  <img src="/intro-4.png" width="100%" alt="Intro">
		</div>
	  {/if}
	  {#if icollage == 5}
		<div class="collage" out:fade={{ duration: 300 }} in:fade={{ duration: 300 }}>
		  <img src="/intro-5.png" width="80%" alt="Intro">
		</div>
	  {/if}
	  {#if icollage == 6}
		<div class="collage" out:fade={{ duration: 300 }} in:fade={{ duration: 300 }}>
		  <img src="/intro-6.png" width="80%" alt="Intro">
		</div>
	  {/if}
	  {#if icollage == 7}
		<div class="collage" out:fade={{ duration: 300 }} in:fade={{ duration: 300 }}>
		  <img src="/intro-7.png" width="100%" alt="Intro">
		</div>
	  {/if}
	  {#if icollage == 8}
		<div class="collage" out:fade={{ duration: 300 }} in:fade={{ duration: 300 }}>
		  <img src="/intro-8.png" width="100%" alt="Intro">
		</div>
	  {/if}
	</div>
  {/if}
  {#if curframe == 1 && flipped}
	<div class="next" on:click={forward}>→</div>
  {/if}
  {#if curframe == 2}
	<div class="title">
	  Overall Housing Market and Investor Activity
	</div>
	<div class="prev" on:click={back}>←</div>
	<div class="next" on:click={forward}>→</div>
	<div class="flexpage">
	  <div class="section" style="flex: 45;">
		<!-- <div in:fly={{ y: -200, duration: 1000 }} class="desp"> -->
		  <!-- 	The luxury housing market, in general, is more profitable than lower-end -->
		  <!-- 	housing markets, resulting in an influx of investors into the market. -->
		  <!-- </div> -->
		<InvestorActivity {transfer} {colorp} {colorq} />
	  </div>
	  <div class="section" style="flex: 55;">
		<!-- <div class="desp"> -->
		  <!-- 	Overall, investors account for more than 80% of the total transactions -->
		  <!-- 	in the luxury housing market. The number significantly drops in the -->
		  <!-- 	lower-end housing markets. -->
		  <!-- </div> -->
		<div id="findings">
		  <ul>
			<li> Flipped properties are much more than profitable
			<li> Investors dominate the luxury housing market
		  </ul>
		</div>
		<div class="histograms">
		  <div class="histpie">
			<div class="pricehist">
			  <PriceHistogram color={colorp} seldata={seldatap} invsel={invselp} />
			</div>
			<div class="invpie">
			  <InvestorPie color={colorp} data={seldatap} invsel={invselp} />
			</div>
		  </div>
		  <div class="histpie">
			<div class="pricehist">
			  <PriceHistogram color={colorq} seldata={seldataq} invsel={invselq} />
			</div>
			<div class="invpie">
			  <InvestorPie color={colorq} data={seldataq} invsel={invselq} />
			</div>
		  </div>
		</div>
	  </div>
	</div>
	<!-- <div class="transfer" style="background: {transfer ? "#FEDA8B" : "#F7F7F7"}" on:click={toggleTransfer}>Apply transfer fee</div> -->
  {/if}
  {#if curframe == 3}
	<div class="title">
	  How Investors Affect the General Public
	</div>
	<div class="items">
	  <ul>
		<li> Collage explain investor's effect in terms of urban economics
	  </ul>
	</div>
  	<div class="prev" on:click={back}>←</div>
	<div class="next" on:click={forward}>→</div>
  {/if}
  {#if curframe == 4}
	<div class="title">
	  Benefit of the Affordable Homes Act
	</div>
	<div class="flexpage">
	  <div class="section" style="flex: 50;">
		<Revenue />
	  </div>
	  <div class="section" style="flex: 50;">
		<Affordable />
	  </div>
	</div>

	<!-- <div class="items"> -->
	<!--   <ul> -->
	<!-- 	<li> Revenue analysis -->
	<!-- 	<li> Equal to how many affordable homes? -->
	<!--   </ul> -->
	<!-- </div> -->
  	<div class="prev" on:click={back}>←</div>
	<div class="next" on:click={forward}>→</div>
  {/if}
  {#if curframe == 5}
	<div class="title">
	  Investor Redistribution
	</div>
	<!-- <div class="items"> -->
	<!--   <ul> -->
	<!-- 	<li> Collage depicting the reasoning of investor redistribution -->
	<!-- 	<li> Potential buyers analysis -->
	<!--   </ul> -->
	<!-- </div> -->
	<div class="flexpage">
	  <div class="section" style="flex: 50;">
		<TaxRate />
	  </div>
	  <div class="section" style="flex: 50;">
	  </div>
	</div>
  	<div class="prev" on:click={back}>←</div>
	<div class="next" on:click={forward}>→</div>
  {/if}
  {#if curframe == 6}
	<div class="title">
	  Estimating and Analyzing the Effect of Investor Redistribution
	</div>
	<div class="items">
	  <ul>
		<li> High housing price
		<li> Less homes on the market
	  </ul>
	</div>
  	<div class="prev" on:click={back}>←</div>
	<div class="next" on:click={forward}>→</div>
  {/if}
  {#if curframe == 7}
	<div class="title">
	  Next Steps
	</div>
	<div class="items">
	  <ul>
		<li> Other state/country's data
		<li> Geographical analysis
		<li> What kinds of homes do investors like?
		<li> More about flipping
		<li> More study on Boston affordable housing due to transfer fee
	  </ul>
	</div>
  	<div class="prev" on:click={back}>←</div>
	<div class="next" on:click={forward}>→</div>
  {/if}
  {#if curframe == 8}
	<div class="title">
	  Conclusion
	</div>
	<div class="items">
	  <ul>
		<li> Summary of our findings and analyses
		<li> Collage showing the pros and cons of transfer fee
	  </ul>
	</div>
  	<div class="prev" on:click={back}>←</div>
  {/if}
</div>

<svelte:window
  on:keydown={handleKeydown}
/>
