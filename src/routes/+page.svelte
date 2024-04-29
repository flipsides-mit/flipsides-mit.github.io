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
  let curframe = 4;
  let phase = 0;
  let colorp = "#4393C3";
  let colorq = "#F67E4B";
  let icollage = 1;
  let curfinding = 0;
  export let duration = 5; // Animation duration in seconds

  function toggleFlip() {
    flipped = !flipped;
  }

  function toFrame(n) {
    return () => {
	  curframe = n;
	}
  }

  function forward() {
	if (curframe < 20) {
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

  .flexbox {
	display: flex;
	justify-content: center;
	align-items: center;
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

  .curtain {
    position: relative;
    overflow: hidden;
    width: 100%;
    height: 100%;
  }

  .curtain-content {
    position: absolute;
    top: 70%;
    transform: translateY(-100%);
    animation: move-left linear infinite;
    animation-duration: 30s;
  }

  @keyframes move-left {
    0% {
      transform: translateX(100%);
    }
    100% {
      transform: translateX(-500%);
    }
  }

  .flex-page-col {
	display: flex;
	justify-content: center;
	align-items: center;
	width: 100%;
	height: 100%;
	flex-direction: column;
  }

  .flex-page-row {
	display: flex;
	justify-content: center;
	align-items: center;
	width: 100%;
	height: 100%;
	flex-direction: row;
  }

  .text-light {
	color: white;
  }

  .bg-dark {
	background: black;
  }

  .relative-page {
	position: relative;
	width: 100%;
	height: 100%;
  }

  .absolute-page {
	position: absolute;
	width: 100%;
	height: 100%;
  }

  img {
    width: 100%;
    height: 100%;
    object-fit: cover; /* Maintains aspect ratio, but crops the image if necessary */
  }
  /* dont crop the image if the class is "move" */
  .move {
    width: 400%;
    height: 400%;
    object-fit: contain;
  }
</style>

<div class="container">
  <div class="relative-page bg-dark">
	{#if curframe == 1}
	  <div class="flex-page-col bg-dark">
		<div style="flex: 1; height: 80%;">
		  <img height="100%" src="/intro-1.png" alt="act">
		</div>
		<div class="text-light" style="flex: 1; font-size: 40px; height: 20%; width: 80%;">
		  In 2023, Massachusetts published the Affordable Homes Acts, introducing the transfer fee to MA for the first time.
		</div>
	  </div>
	{/if}
	{#if curframe == 2}
	  <div class="flexbox"
		   style="width: 70%; position: absolute; bottom: 45%; left: 15%;
				  font-size: 40px; color: white;"
		   transition:fade={{ duration: 300 }}>
		The Affordable Homes Act includes a provision that would grant
		Massachusetts municipalities the authority to implement a real estate
		transfer fee of 0.5% to 2.0% on transactions or more than $1M or the
		county median single family home price, whichever is greater.
	  </div>
      <div class="curtain">
		<div class="curtain-content">
          <img src="/houses-all.png" class="move" alt="Moving figure">
		</div>
      </div>
	{/if}
	{#if curframe == 3 || curframe == 4}
	  <div class="flexbox"
		   style="width: 47%; position: absolute; bottom: 70%; left: 3%;
				  font-size: 36px; color: white;"
		   transition:fade={{ duration: 300 }}>
		According to the 2022 Greater Boston Area housing transaction data, it
		is preliminarily estimated that the implementation of this policy in
		2023 will generate $208 million in revenue for affordable housing.
	  </div>
	  <div class="flexbox"
		   style="width: 47%; position: absolute; bottom: 20%; left: 3%;
				  font-size: 80px; color: white;"
		   transition:fade={{ duration: 300 }}>
		<center>
		  $208M<br>
		  <tspan style="visibility: {curframe == 4 ? 'visible' : 'hidden'};">=<br>
			2000 units</tspan>
		  <tspan style="font-size: 25px; visibility: {curframe == 4 ? 'visible' : 'hidden'};">
			<br>(estimation based on
			<a href="https://www.boston.gov/sites/default/files/file/2022/04/Income%20Restricted%20Housing%20Report%2C%202021_0.pdf">
			  Income-Restricted Housing in Boston 2021)
			</a>
		  </tspan>
	  </div>
	  <div style="position: absolute; right: 3%; bottom: 0%; width: 45%;"
		   transition:fade={{ duration: 300 }}>
		<img src="/base.png" alt="act">
	  </div>
	{/if}
	{#if curframe == 4}
	  <div style="position: absolute; right: 2%; bottom: 20%; width: 42%;"
		   transition:fly={{ duration: 300, y: '-30%' }}>
		<img src="/addition.png" alt="act">
	  </div>
	{/if}
	{#if (5 <= curframe && 8 >= curframe) || (10 == curframe )}
	  <div style="position: absolute; width: 100%; height: 99%;">
		<img src="/houses-dark.png" alt="act">
	  </div>
	{/if}
	{#if curframe == 5 || curframe == 6}
	  <div style="position: absolute; width: 100%; height: 99%; opacity: 30%;"
		   transition:fade={{ duration: 300 }}>
		<img src="/people.png" alt="act">
	  </div>
	{/if}
	{#if (6 <= curframe) && (8 >= curframe)}
	  <div style="position: absolute; width: 100%; height: 99%;"
		   transition:fade={{ duration: 300 }}>
		<img src="/people-red.png" alt="act">
	  </div>
	{/if}
	{#if curframe == 5}
	  <div class="text-light"
		   style="position: absolute; width: 40%; top: 40%; left: 30%; font-size: 35pt;"
		   transition:fade={{ duration: 300 }}>
		But who's actually paying for the 2000 units of affordable housing?
	  </div>
	{/if}
	{#if curframe >= 8 && curframe <= 9}
	  <div class="bg-dark"
		   style="position: absolute; width: 100%; height: 30%; bottom: 0%; font-size: 25pt;"
		   transition:fade={{ duration: 300 }}>
	  </div>
	{/if}
	{#if curframe == 7}
	  <div class="bg-dark"
		   style="position: absolute; width: 100%; height: 99%; bottom: 0%; font-size: 25pt;"
		   transition:fade={{ duration: 300 }}>
	  </div>
	  <div class="text-light"
		   style="position: absolute; width: 45%; height: 34%; bottom: 25%; left: 40%;
				  font-size: 25pt;"
		   transition:fade={{ duration: 300 }}>
		<center>
		  -- Tim --<br><br>
		  An MIT graduate, the middle class represent, just got an offer
		  from a tech company in Boston whose annual household income is
		  around $150k~200k. Tim is looking for a house in Boston with his
		  family.
	  </div>
	  <div style="position: absolute; height: 60%; bottom: 16%; left: 10%;"
		   transition:fade={{ duration: 300 }}>
		<img src="/tim-bg.png" style="object-fit: contain;" alt="tim-bg">
	  </div>
	  <div style="position: absolute; height: 60%; bottom: 20%; left: 20%;"
		   transition:fade={{ duration: 300 }}>
		<img src="/tim.png" style="object-fit: contain;" alt="tim">
	  </div>
	{/if}
	{#if curframe >= 8 && curframe <= 9}
	  <div style="position: absolute; height: 40%; bottom: 1%; left: 15%;"
		   transition:fade={{ duration: 300 }}>
		<img src="/tim.png" style="object-fit: contain;" alt="tim">
	  </div>
	{/if}
	{#if curframe == 8}
	  <div class="text-light"
		   style="position: absolute; width: 59%; height: 24%; bottom: 0%; left: 35%;
				  font-size: 25pt;"
		   transition:fade={{ duration: 300 }}>
		Tim finds out that if he wants to keep his round-trip commute time to
		work under 1 hour while also being able to support his household and
		lifestyle needs, there were not many options for houses under $1million.
	  </div>
	{/if}
	{#if curframe == 9}
	  <div class="text-light"
		   style="position: absolute; width: 59%; height: 24%; bottom: 0%; left: 35%;
				  font-size: 25pt;"
		   transition:fade={{ duration: 300 }}>
		Ultimately, Tim set his sights on a house priced at $1.3 million -
		which means he has to pay $30000 as the transfer fee, about his 2
		months salary.
	  </div>
	  <div style="position: absolute; width: 100%; height: 65%;"
		   transition:fly={{ duration: 300, y: '-30%' }}>
		<img src="/condo.png" style="object-fit: contain;" alt="act">
	  </div>
	{/if}
	{#if curframe == 10}
	  <div style="position: absolute; width: 100%; height: 99%;"
		   transition:fade={{ duration: 300 }}>
		<img src="/people-blue.png" alt="act">
	  </div>
	{/if}
	{#if curframe == 11}
	  <div class="bg-dark"
		   style="position: absolute; width: 100%; height: 99%; bottom: 0%; font-size: 25pt;"
		   transition:fade={{ duration: 300 }}>
	  </div>
	  <div class="text-light"
		   style="position: absolute; width: 45%; height: 34%; bottom: 25%; left: 40%;
				  font-size: 25pt;"
		   transition:fade={{ duration: 300 }}>
		<center>
		  -- Joe -- <br><br> An agency from an investor company, pays more
		  attention in looking for a luxury house here, aiming around $6~7
		  million.
	  </div>
	  <div style="position: absolute; height: 60%; bottom: 16%; left: 10%;"
		   transition:fade={{ duration: 300 }}>
		<img src="/joe-bg.png" style="object-fit: contain;" alt="joe-bg">
	  </div>
	  <div style="position: absolute; height: 60%; bottom: 20%; left: 20%;"
		   transition:fade={{ duration: 300 }}>
		<img src="/joe.png" style="object-fit: contain;" alt="joe">
	  </div>
	{/if}
	{#if curframe == 12}
	  <div style="position: absolute; height: 40%; bottom: 1%; right: 10%;"
		   transition:fade={{ duration: 300 }}>
		<img src="/joe.png" style="object-fit: contain;" alt="joe">
	  </div>
	  <div class="text-light"
		   style="position: absolute; width: 59%; height: 24%; bottom: 0%;
				  right: 30%; font-size: 25pt;" transition:fade={{ duration: 300
		   }}> Ultimately, Joe set his sights on a house priced at $6~7
		million-which means they has to pay about $550000 as the
		transfer fee.  Meanwhile, they can earn $5000000 as profit by
		flipping house, which is 10 times than their cost of transfer
		fee.
	  </div>
	{/if}
	{#if curframe == 13 || curframe == 14}
	  <div style="position: absolute; height: 30%; bottom: 3%; left: 15%;"
		   transition:fade={{ duration: 300 }}>
		<img src="/tim.png" style="object-fit: contain;" alt="tim">
	  </div>
	  <div style="position: absolute; height: 30%; bottom: 3%; left: 32%;"
		   transition:fade={{ duration: 300 }}>
		<img src="/joe.png" style="object-fit: contain;" alt="joe">
	  </div>
	  <div class="flexpage" style="position: absolute; top: -25%; color: white;">
		<div class="section" style="flex: 45; height: 70%; top: 10%; padding-left: 2%;">
		  <InvestorActivity {curframe} {colorp} {colorq} />
		</div>
		<div class="section" style="flex: 55; height: 70%; top: 10%; padding-right: 2%;">
		  <div class="histograms">
			<div class="histpie">
			  <div class="pricehist">
				<PriceHistogram color={colorp} seldata={seldatap} invsel={invselp} />
			  </div>
			  <div class="invpie">
				<InvestorPie {curframe} id={0} color={colorp} data={seldatap} invsel={invselp} />
			  </div>
			</div>
			<div class="histpie">
			  <div class="pricehist">
				<PriceHistogram color={colorq} seldata={seldataq} invsel={invselq} />
			  </div>
			  <div class="invpie">
				<InvestorPie {curframe} id={1} color={colorq} data={seldataq} invsel={invselq} />
			  </div>
			</div>
		  </div>
		</div>
	  </div>
	{/if}
	{#if curframe == 15}
	  <div class="bg-dark"
		   style="position: absolute; width: 100%; height: 99%; bottom: 0%; font-size: 25pt;"
		   transition:fade={{ duration: 300 }}>
	  </div>
	  <div class="text-light"
		   style="position: absolute; width: 40%; height: 34%; bottom: 30%; left: 28%;
				  font-size: 25pt;"
		   transition:fade={{ duration: 300 }}>
		<center>
		  It seems that the <tspan style="color: red;">middle-class
			majority</tspan>, represented by Tim, are paying a significant amount
		  of transfer fees; <br><br>meanwhile,
		  <tspan style="color: cyan;">investors</tspan> are able to cover their
		  transfer fee expenses through the profits gained from flipping houses.
	  </div>
	  <div style="position: absolute; height: 60%; bottom: 16%; left: 5%;"
		   transition:fade={{ duration: 300 }}>
		<img src="/tim-bg.png" style="object-fit: contain;" alt="tim-bg">
	  </div>
	  <div style="position: absolute; height: 60%; bottom: 20%; left: 15%;"
		   transition:fade={{ duration: 300 }}>
		<img src="/tim.png" style="object-fit: contain;" alt="tim">
	  </div>
	  <div style="position: absolute; height: 60%; bottom: 16%; right: 5%;"
		   transition:fade={{ duration: 300 }}>
		<img src="/joe-bg.png" style="object-fit: contain;" alt="joe-bg">
	  </div>
	  <div style="position: absolute; height: 60%; bottom: 20%; right: 10%;"
		   transition:fade={{ duration: 300 }}>
		<img src="/joe.png" style="object-fit: contain;" alt="joe">
	  </div>
	{/if}
	{#if curframe == 16}
	  <div class="flexbox"
		   style="width: 42%; position: absolute; bottom: 38%; left: 15%;
				  font-size: 35px; color: white;"
		   transition:fade={{ duration: 300 }}>
		Due to the large number of the middle class, people like Tim, who
		purchase homes in the 1M to 2M (and even 2M to 3M) range, have become
		the primary group paying the transfer fee.
	  </div>
	{/if}
	{#if curframe == 16 || curframe == 17}
	  <div style="position: absolute; height: 30%; bottom: 3%; left: 12%;"
		   transition:fade={{ duration: 300 }}>
		<img src="/tim.png" style="object-fit: contain;" alt="tim">
	  </div>
	  <div class="flexpage" style="color: white; fill: white;">
		<div class="section"
			 style="flex: 0; height: 80%; top: 5%;">
		</div>
		<div class="section" style="flex: 100; height: 80%; top: 5%;">
		  <TaxGroup />
		</div>
	  </div>
	{/if}
	{#if curframe == 17}
	  <div class="flexbox"
		   style="width: 100%; position: absolute; top: 5%; font-size: 45px; color: white;">
		How should we adjust the policy, for a more equitable distribution of resources?
	  </div>
	  <div style="position: absolute; height: 30%; bottom: 3%; left: 63%;"
		   transition:fade={{ duration: 300 }}>
		<img src="/joe.png" style="object-fit: contain;" alt="joe">
	  </div>
	{/if}
  </div>
</div>

<svelte:window
  on:keydown={handleKeydown}
  />
