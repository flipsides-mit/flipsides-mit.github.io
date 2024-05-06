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
  let progressTax;
  let progressQuestion;
  let progressTim;
  let progressJoe;

  $: console.log('tax prog', progressTax);

  $: console.log('question prog', progressQuestion);

  $: console.log('tim prog', progressTim);

  $: console.log('joe prog', progressJoe);

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

  let taxGroupTran = createUpDownTransition(20, 50, 70, 90);
  $: alphaBg = 1 - taxGroupTran(progressTax);
  $: opacityBg = 0.3 * alphaBg;
  $: opacityTaxGroup = taxGroupTran(progressTax);

  // Questions
  let peopleColorPhase1Tran = createUpDownTransition(10, 60, 80, 90);
  let peopleColorPhase2Tran = createUpDownTransition(60, 70, 80, 90);
  $: opacityPeopleColor = 0.3 * peopleColorPhase1Tran(progressQuestion) + 0.7 * peopleColorPhase2Tran(progressQuestion);
  let peopleTextTran = createUpTransition(60, 70);
  $: opacityPeopleText = 1 - peopleTextTran(progressQuestion);

  // Tim
  let peopleRedTran = createUpDownTransition(75, 75, 95, 100);
  $: opacityPeopleRed = peopleRedTran(progressQuestion);
  let timTran = createUpDownTransition(0, 20, 90, 100);
  $: opacityTim = timTran(progressTim);

  // Investors and Joe
  let peopleBlueTran = createUpDownTransition(0, 5, 20, 30);
  $: opacityPeopleBlue = peopleBlueTran(progressJoe)
  let joeTran = createUpDownTransition(25, 35, 90, 100);
  $: opacityJoe = joeTran(progressJoe);

  // color
  let colortim = "#CF1F3F";
  let colorjoe = "#77ABD3";

  // housing market and investor activity
  let phase = 0;
  let colorp = "#4393C3";
  let colorq = "#F67E4B";
</script>

<div style="position: fixed; top: 0%; left: 0%; width: 100vw; height: 100vh;
			opacity: {opacityBg}; z-index: 1;">
  <img src="/houses-dark.png" alt="houses-bg">
</div>

<div style="position: fixed; top: 0%; left: 0%; width: 100vw; height: 100vh;
			opacity: {opacityPeopleColor}; z-index: 1;">
  <img src="/people.png" alt="people-bg">
</div>

<div style="position: fixed; top: 0%; left: 0%; width: 100vw; height: 100vh;
			opacity: {opacityPeopleRed}; z-index: 1;">
  <img src="/people-red.png" alt="people-red-bg">
</div>

<div style="position: fixed; top: 0%; left: 0%; width: 100vw; height: 100vh;
			opacity: {opacityTim}; z-index: 1;">
  <div style="position: absolute; height: 60%; bottom: 16%; left: 10%;">
	<img src="/tim-bg.png" style="object-fit: contain;" alt="tim-bg">
  </div>
  <div style="position: absolute; height: 60%; bottom: 20%; left: 20%;">
	<img src="/tim.png" style="object-fit: contain;" alt="tim">
  </div>
</div>

<div style="position: fixed; top: 0%; left: 0%; width: 100vw; height: 100vh;
			opacity: {opacityPeopleBlue}; z-index: 1;">
  <img src="/people-blue.png" alt="people-blue-bg">
</div>

<div style="position: fixed; top: 0%; left: 0%; width: 100vw; height: 100vh;
			opacity: {opacityJoe}; z-index: 1;">
  <div style="position: absolute; height: 60%; bottom: 16%; right: 15%;">
	<img src="/joe-bg.png" style="object-fit: contain;" alt="joe-bg">
  </div>
  <div style="position: absolute; height: 60%; bottom: 20%; right: 10%;">
	<img src="/joe.png" style="object-fit: contain;" alt="joe">
  </div>
</div>

<div style="position: relative; color: white; background-color: rgb(0 0 0 / {alphaBg});">

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
  </Scrolly>


  <Scrolly bind:progress={progressTax} threshold={0.9} margin={innerHeight * 0.1} --scrolly-layout="overlap" >
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
