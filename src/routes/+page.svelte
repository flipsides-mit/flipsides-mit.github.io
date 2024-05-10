<script>
  import { onMount } from 'svelte';
  import Scrolly from 'svelte-scrolly';
  import Scroller from "@sveltejs/svelte-scroller";
  import TaxGroup from './tax-group.svelte';
  import TaxControl from './tax-control.svelte';
  import Revenue from './revenue.svelte';
  // housing market and investor activity
  import InvestorActivity from './investor-activity.svelte';
  import PriceHistogram from './price-histogram.svelte';
  import InvestorPie from './investor-pie.svelte';
  import { seldatap, seldataq, invselp, invselq } from './stores.js';

  let innerHeight;
  let progressOpening;
  let progressQuestion;
  let progressTim;
  let progressJoe;
  let progressHousing;
  let progressTax;

  $: console.log('opening prog', progressOpening);

  $: console.log('question prog', progressQuestion);

  $: console.log('tim prog', progressTim);

  $: console.log('joe prog', progressJoe);

  $: console.log('housing prog', progressHousing);

  $: console.log('tax prog', progressTax);

  function createUpDownTransition(begin, peakb, peake, end) {
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

  function createUpTransition(begin, peak) {
	return (progress) => {
	  if (progress < begin) {
		return 0;
	  }
	  if (progress < peak) {
		return (progress - begin) / (peak - begin);
	  }
	  return 1;
	}
  }

  function scaleTran(begin, end, tran) {
	return (progress) => {
	  let d = end - begin;
	  return begin + tran(progress) * d;
	}
  }

  // Opening
  let openingTran = createUpTransition(0, 80);
  $: opacityOpening = 1 - openingTran(progressOpening);

  // Questions
  let peopleColorPhase1Tran = createUpDownTransition(10, 60, 80, 90);
  let peopleColorPhase2Tran = createUpDownTransition(60, 70, 80, 90);
  $: opacityPeopleColor =
  0.3 * peopleColorPhase1Tran(progressQuestion) +
  0.7 * peopleColorPhase2Tran(progressQuestion);
  let peopleTextTran = createUpTransition(60, 70);
  $: opacityPeopleText = 1 - peopleTextTran(progressQuestion);

  // Tim
  let peopleRedTran = createUpDownTransition(75, 75, 95, 100);
  $: opacityPeopleRed = peopleRedTran(progressQuestion);
  let timTran = createUpDownTransition(0, 20, 90, 100);
  $: opacityTim = timTran(progressTim);

  // Investors and Joe
  let peopleBlueTran = createUpDownTransition(0, 5, 15, 20);
  $: opacityPeopleBlue = peopleBlueTran(progressJoe)
  let joeTran = createUpDownTransition(20, 25, 90, 100);
  $: opacityJoe = joeTran(progressJoe);

  // Housing market
  let marketTran = createUpDownTransition(10, 20, 90, 100);
  $: opacityMarket = marketTran(progressHousing);
  let topMarketCard1Tran = scaleTran(0, 40, createUpDownTransition(30, 35, 45, 50));
  $: topMarketCard1 = topMarketCard1Tran(progressHousing);
  let topMarketCard2Tran = scaleTran(0, 40, createUpDownTransition(50, 55, 65, 70));
  $: topMarketCard2 = topMarketCard2Tran(progressHousing);
  let topMarketCard3Tran = scaleTran(0, 40, createUpDownTransition(70, 75, 85, 90));
  $: topMarketCard3 = topMarketCard3Tran(progressHousing);

  // Tax group
  let taxGroupTran = createUpDownTransition(40, 50, 70, 90);
  $: opacityTaxGroup = taxGroupTran(progressTax);
  let topTaxGroupCard1Tran = scaleTran(0, 60, createUpDownTransition(50, 60, 70, 80));
  $: topTaxGroupCard1 = topTaxGroupCard1Tran(progressTax);
  let taxControlHeightTran = scaleTran(50 * 0.75, 50, createUpTransition(50, 55));
  $: taxControlHeight = taxControlHeightTran(progressTax);
  $: sepTax = progressTax < 55 ? true : false;

  // Tax group control variables
  let noninv = true;
  let inv = true;
  let rateNoninv = 0.01;
  let rateInv = 0.01;
  let taxThrd = 1000000;
  let sumInv = 0;
  let sumNoninv = 0;
  $: sum = sumInv + sumNoninv;

  // Backgroud
  $: alphaBg = 1 - opacityTaxGroup - opacityMarket;
  $: opacityBg = 0.3 * alphaBg;

  let zidxBg = 1;
  $: {
	if ((70 <= progressHousing && progressHousing < 100) || (50 <= progressTax && progressTax < 80)) {
	  zidxBg = 0;
	} else {
	  zidxBg = 1;
	}
  }

  // color
  let colortim = "#CF1F3F";
  let colorjoe = "#77ABD3";

  // housing market and investor activity
  let phase = 0;
  let colorp = "#4393C3";
  let colorq = "#F67E4B";
</script>

<div style="position: fixed; top: 0%; left: 0%; width: 100vw; height: 100vh;
			opacity: {opacityOpening}; z-index: {zidxBg};">
  <img src="/houses.png" alt="houses-color-bg">
</div>

<div style="position: fixed; top: 0%; left: 0%; width: 100vw; height: 100vh;
			opacity: {opacityBg}; z-index: {zidxBg};">
  <img src="/houses-dark.png" alt="houses-bg">
</div>

<div style="position: fixed; top: 0%; left: 0%; width: 100vw; height: 100vh;
			opacity: {opacityPeopleColor}; z-index: {zidxBg};">
  <img src="/people.png" alt="people-bg">
</div>

<div style="position: fixed; top: 0%; left: 0%; width: 100vw; height: 100vh;
			opacity: {opacityPeopleRed}; z-index: {zidxBg};">
  <img src="/people-red.png" alt="people-red-bg">
</div>

<div style="position: fixed; top: 0%; left: 0%; width: 100vw; height: 100vh;
			opacity: {opacityTim}; z-index: {zidxBg};">
  <div style="position: absolute; height: 60%; bottom: 16%; left: 10%;">
	<img src="/tim-bg.png" style="object-fit: contain;" alt="tim-bg">
  </div>
  <div style="position: absolute; height: 60%; bottom: 20%; left: 20%;">
	<img src="/tim.png" style="object-fit: contain;" alt="tim">
  </div>
</div>

<div style="position: fixed; top: 0%; left: 0%; width: 100vw; height: 100vh;
			opacity: {opacityPeopleBlue}; z-index: {zidxBg};">
  <img src="/people-blue.png" alt="people-blue-bg">
</div>

<div style="position: fixed; top: 0%; left: 0%; width: 100vw; height: 100vh;
			opacity: {opacityJoe}; z-index: {zidxBg};">
  <div style="position: absolute; height: 60%; bottom: 16%; right: 15%;">
	<img src="/joe-bg.png" style="object-fit: contain;" alt="joe-bg">
  </div>
  <div style="position: absolute; height: 60%; bottom: 20%; right: 10%;">
	<img src="/joe.png" style="object-fit: contain;" alt="joe">
  </div>
</div>

<div style="position: relative; color: white; background-color: rgb(0 0 0 / {alphaBg});">

  <!-- Opening -->
  <Scrolly bind:progress={progressOpening} threshold={0} margin={0} --scrolly-layout="overlap" >
	<div style="height: 120vh;" />
	<svelte:fragment slot="viz">
	</svelte:fragment>
  </Scrolly>

  <!-- Intro of Affordable Homes Act -->
  <div class="flexpage flex-col">
	<div style="flex: 1; height: 80%;">
	  <img height="100%" src="/intro-1.png" alt="act">
	</div>
	<div style="flex: 1; font-size: 40px; height: 20%; width: 80%;">
	  In 2023, Massachusetts published the Affordable Homes Acts, introducing the <tspan style="color: #EE7733;">transfer fee</tspan> to MA for the first time.
	</div>
  </div>

  <!-- Transfer fee -->
  <div class="relpage">
	<div style="width: 70%; position: absolute; bottom: 45%; left: 15%;
				font-size: 40px;">

	  The Affordable Homes Act includes a provision that would grant
	  Massachusetts municipalities the authority to implement a real estate
	  transfer fee of <tspan style="color: #EE7733;">0.5% to 2.0%</tspan> on
	  transactions of more than $1M or the county median single family home
	  price, whichever is greater.
	</div>
  </div>

  <!-- New affordable homes -->
  <div class="relpage">
	<div style="width: 47%; position: absolute; bottom: 70%; left: 3%;
				font-size: 36px;">

	  According to the 2022 Greater Boston Area housing transaction data, it is
	  preliminarily estimated that the implementation of this policy in 2023
	  will generate <tspan style="color: #EE7733;">$208 million</tspan> in
	  revenue for affordable housing.
	</div>
	<div class="flexbox flex-row"
		 style="width: 47%; position: absolute; bottom: 15%; left: 3%;
				font-size: 80px;">
	  <center>
		$208M<br>
		≈<br>
		2000 units
		<tspan style="font-size: 25px;">
		  <br>(estimation based on
		  <a href="https://www.boston.gov/sites/default/files/file/2022/04/Income%20Restricted%20Housing%20Report%2C%202021_0.pdf">
			Income-Restricted Housing in Boston 2021)
		  </a>
		</tspan>
	</div>
	<div style="position: absolute; right: 3%; bottom: 0%; width: 45%;">
	  <img src="/base.png" alt="act">
	</div>
  </div>

  <!-- Main question -->
  <Scrolly bind:progress={progressQuestion} threshold={1} margin={0} --scrolly-layout="overlap" >
	<div class="relpage" style="height: 300vh;">
	  <div class="stickybox textbox"
		   style="top: 20%; font-size: 50pt; padding: 15%;
				  opacity: {opacityPeopleText};">
		But <tspan style="color: #EE7733;">who's</tspan> actually paying for the 2000 units of affordable housing?
	  </div>
	</div>
	<svelte:fragment slot="viz">
	</svelte:fragment>
  </Scrolly>

  <!-- Tim -->
  <Scrolly bind:progress={progressTim} threshold={1} margin={0} --scrolly-layout="overlap" >
	<div class="relpage" style="height: 80vh;">
	  <div style="position: absolute; width: 45%; height: 34%; top: 0%; left: 40%;
				  font-size: 25pt;">
		<center>
		  -- Tim --<br><br>
		  An MIT graduate, the <tspan style="color: {colortim};">middle class</tspan> represent, just got an offer
		  from a tech company in Boston whose annual household income is
		  around $150k~200k. Tim is looking for a house in Boston with his
		  family.
	  </div>
	</div>
	<div class="relpage" style="height: 80vh;">
	  <div style="position: absolute; width: 50%; height: 24%; bottom: 0%; left: 40%;
				  font-size: 25pt;">
		Ultimately, Tim sets his sights on a house priced
		at <tspan style="color: #EE7733;">$1.3M</tspan> - which means he
		has to pay <tspan style="color: #EE7733;">$3K</tspan> as the transfer
		(assuming an 1% tax rate).
	  </div>
	  <div style="position: absolute; height: 80%; left: 30%;">
		<img src="/condo.png" style="object-fit: contain;" alt="condo">
	  </div>
	</div>
	<div style="height: 100vh;" />
  </Scrolly>

  <!-- Joe -->
  <Scrolly bind:progress={progressJoe} threshold={1} margin={0} --scrolly-layout="overlap" >
	<div style="height: 100vh;" />
	<div class="relpage" style="height: 80vh;">
	  <div style="position: absolute; width: 45%; height: 34%; top: 0%; left: 5%;
				  font-size: 25pt;">
		<center>
		  -- Joe -- <br><br> An agency from an investor company, looking for
		  properties to invest in the Great Boston Area.
	  </div>
	</div>
	<div class="relpage" style="height: 80vh;">
	  <div style="position: absolute; width: 50%; height: 24%; bottom: 0%; left: 5%;
				  font-size: 25pt;">
		
		Now, let's take a look what kinds of properties investors like and how much
		profit they can make in the housing market!
	  </div>
	  <div style="position: absolute; height: 80%; left: -5%; bottom: 25%;">
		<img src="/single-family.png" style="object-fit: contain;" alt="single-family">
	  </div>
	</div>
	<div style="height: 100vh;" />
	<svelte:fragment slot="viz">
	</svelte:fragment>
  </Scrolly>

  <!-- Interactive visualization: Housing market and investor activity -->
  <Scrolly bind:progress={progressHousing} threshold={0.95} margin={innerHeight * 0.05} --scrolly-layout="overlap" >
	<div style="height: 300vh;" />
	<svelte:fragment slot="viz">
	  <div class="text-dark" style="opacity: {opacityMarket};">
		<div style="position: absolute; height: 50%; width: 50%; left: 5%;">
		  <InvestorActivity phase={1} {colortim} {colorjoe} />
		</div>
		<div style="position: absolute; height: 30%; width: 40%; right: 5%; bottom: 10%;">
		  <PriceHistogram color={colorjoe} seldata={seldatap} invsel={invselp} />
		</div>
		<div style="position: absolute; height: 30%; width: 20%; right: 0%; bottom: 20%;">
		  <InvestorPie id={0} color={colorjoe} data={seldatap} invsel={invselp} />
		</div>
		<div style="position: absolute; height: 30%; width: 40%; left: 5%; bottom: 10%;">
		  <PriceHistogram color={colortim} seldata={seldataq} invsel={invselq} />
		</div>
		<div style="position: absolute; height: 30%; width: 20%; left: 30%; bottom: 20%;">
		  <InvestorPie id={1} color={colortim} data={seldataq} invsel={invselq} />
		</div>
	  </div>
	</svelte:fragment>
  </Scrolly>

  <!-- Housing market cards -->
  <div class="card"
	   style="position: fixed; font-size: 20pt; color: black;
			  width: 30%; right: 5%; top: {topMarketCard1}%; transform: translateY(-100%);">
	<tspan style="font-weight: bold;">Key finding 1: </tspan> Investors make ~2x profit as non-investors,
	<tspan>and this gap becomes even larger when it comes to flipped properties.</tspan>
  </div>

  <div class="card"
	   style="position: fixed; font-size: 20pt; color: black;
			  width: 30%; right: 5%; top: {topMarketCard2}%; transform: translateY(-100%);">
	<tspan style="font-weight: bold;">Key finding 2: </tspan> Investors generally prefer the luxury housing markets.
  </div>

  <div class="card"
	   style="position: fixed; font-size: 20pt; color: black;
			  width: 30%; right: 5%; top: {topMarketCard3}%; transform: translateY(-100%);">
	Select two markets and compare their revenue on your own!
  </div>

  <!-- Key result: Non-investors paying too much fee -->
  <div class="relpage" style="height: 100vh">
  	<div style="position: absolute; width: 40%; height: 40%; top: 35%; left: 29%;
				font-size: 25pt;">
	  <center>
		It seems that the <tspan style="color: {colortim};">middle-class
		  majority</tspan>, represented by Tim, are paying a significant amount
		of transfer fees; <br><br>meanwhile,
		<tspan style="color: cyan;">investors</tspan> are able to cover their
		transfer fee expenses through the much higher profits, potentially
		from flipping houses.
	</div>
	<div style="position: absolute; height: 50%; width: 30%; top: 25%; transform: translate(0%, 10%);">
	  <img src="/tim-bg.png" style="object-fit: contain;" alt="tim-bg">
	</div>
	<div style="position: absolute; height: 50%; width: 30%; top: 25%; transform: translate(0%, 10%);">
	  <img src="/tim.png" style="object-fit: contain;" alt="tim">
	</div>
	<div style="position: absolute; height: 50%; width: 30%; top: 25%; transform: translate(230%, 10%);">
	  <img src="/joe-bg.png" style="object-fit: contain;" alt="joe-bg">
	</div>
	<div style="position: absolute; height: 50%; width: 30%; top: 25%; transform: translate(230%, 10%);">
	  <img src="/joe.png" style="object-fit: contain;" alt="joe">
	</div>
  </div>

  <!-- Interactive visualization: Tax group breakdown -->
  <Scrolly bind:progress={progressTax} threshold={0.9} margin={innerHeight * 0.1} --scrolly-layout="overlap" >
	<div class="flexpage textbox" style="font-size: 45px;">
	  Let's dive into who's actually paying for the transfer fee!
	</div>
	<div style="height: 300vh;" />
	<svelte:fragment slot="viz">
	  <div class="text-dark" style="position: aboslute; height: 80vh; width: 65%; opacity: {opacityTaxGroup};">
		<TaxGroup
		  bind:sumNoninv bind:sumInv
		  {colortim} {colorjoe} {noninv} {inv} {rateNoninv} {rateInv} {taxThrd}
		  showtool={false} />
	  </div>
	  <div class="shaded" style="position: fixed; top: 25%; right: 2%; height: {taxControlHeight}vh; width: 30%; opacity: {opacityTaxGroup};">
	  </div>
	  <div class="text-dark" style="position: fixed; top: 25%; right: 2%; height: 50vh; width: 30%; opacity: {opacityTaxGroup};">
		<TaxControl
		  bind:noninv bind:inv bind:rateNoninv bind:rateInv bind:taxThrd bind:sepTax />
	  </div>
	  <div class="text-dark" style="position: fixed; bottom: 10%; right: 5%; opacity: {opacityTaxGroup}; font-size: {innerHeight * 0.04}px;">
		Revenue (non-investors): ${(sumNoninv / 1000000).toFixed(0)} M ({((sumNoninv / sum) * 100).toFixed(0)}%)<br>
		Revenue (investors): ${(sumInv / 1000000).toFixed(0)} M ({((sumInv / sum) * 100).toFixed(0)}%)<br>
		Total revenue: ${(sum / 1000000).toFixed(0)} M
	  </div>
	</svelte:fragment>
  </Scrolly>

  <!-- Tax group cards -->
  <div class="card"
	   style="position: fixed; font-size: 20pt; color: black;
			  width: 40%; left: 24%; top: {topTaxGroupCard1}%; transform: translateY(-100%);">
	Due to the large number of the middle class, people like Tim, who
	purchase homes in the 1M to 2M (and even 2M to 3M) range, have become
	the primary group paying the transfer fee.
  </div>

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
  <div class="flexpage textbox" style="font-size: 45px;">
  	Credit (TODO): 6.C85 staffs, MAPC, and Warren Group.
  </div>

  <div style="height: 50%;" />
</div>

<svelte:window bind:innerHeight />

<style>
  .relpage {
	position: relative;
	width: 100%;
	height: 100vh;
	z-index: 2;
  }
  .flexpage {
	position: relative;
	display: flex;
	justify-content: center;
	align-items: center;
	width: 100%;
	height: 100vh;
	z-index: 2;
  }
  .stickybox {
	position: sticky;
	width: 100%;
	z-index: 2;
  }
  .textbox {
	box-sizing: border-box;
	padding: 10%;
  }
  .flexbox {
	display: flex;
	justify-content: center;
	align-items: center;
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
  .card {
	background: #F7F7F7;
	color: black;
    font-size: 20px;
	border-radius: 20px;
	padding: 25px;
  }
  .shaded {
	border-radius: 25px;
	box-shadow: rgba(17, 17, 26, 0.1) 0px 4px 16px, rgba(17, 17, 26, 0.1) 0px 8px 24px, rgba(17, 17, 26, 0.1) 0px 16px 56px;
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
