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
  let progressAffordable;
  let progressQuestion;
  let progressTim;
  let progressJoe;
  let progressHousing;
  let progressTax;

  $: console.log('opening prog', progressOpening);

  $: console.log('affordable prog', progressAffordable);

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

  function createPhase(thrds) {
	return (progress) => {
	  for (let i = 0; i < thrds.length; i++) {
		if (progress < thrds[i]) {
		  return i;
		}
	  }
	  return thrds.length;
	}
  }

  function scaleTran(begin, end, tran) {
	return (progress) => {
	  let d = end - begin;
	  return begin + tran(progress) * d;
	}
  }

  function scaleDiscreteTran(begin, end, tran) {
	return (progress) => {
	  let d = end - begin;
	  return begin + Math.floor(tran(progress) * d);
	}
  }

  // Opening
  let openingTran = createUpTransition(70, 100);
  $: opacityOpening = 1 - openingTran(progressOpening);
  let openingFrameTran = scaleDiscreteTran(1, 12, createUpTransition(0, 20))
  $: openingFrame = openingFrameTran(progressOpening);

  // Fee
  let opacityFeeTran = createUpTransition(35, 40);
  $: opacityFee = 1 - opacityFeeTran(progressAffordable);

  // Affordable
  let opacityAffordableTran = createUpDownTransition(40, 45, 90, 100);
  $: opacityAffordable = opacityAffordableTran(progressAffordable);
  let opacityAffordableCalcTran = createUpDownTransition(80, 85, 90, 100);
  $: opacityAffordableCalc = opacityAffordableCalcTran(progressAffordable);
  let opacityBuildingTran = createUpTransition(90, 100);
  $: opacityBuilding = 1 - opacityBuildingTran(progressAffordable);

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

  // Tim animation
  let walkingTimTran = scaleDiscreteTran(0, 40, createUpTransition(0, 20))
  let walkingTim = 1;
  $: {
	let step = walkingTimTran(progressTim);
	walkingTim = step == 40 ? 15 : step % 14 + 1;
  }
  
  let timXTran = scaleTran(-100, 20, createUpTransition(0, 20))
  $: timX = timXTran(progressTim);

  $: console.log(walkingTim);

  // Investors and Joe
  let peopleBlueTran = createUpDownTransition(0, 5, 15, 20);
  $: opacityPeopleBlue = peopleBlueTran(progressJoe);
  let joeTran = createUpDownTransition(20, 25, 90, 100);
  $: opacityJoe = joeTran(progressJoe);

  // Joe animation
  let walkingJoeTran = scaleDiscreteTran(0, 40, createUpTransition(25, 45))
  let walkingJoe = 1;
  $: {
	let step = walkingJoeTran(progressJoe);
	walkingJoe = step == 40 ? 10 : step % 9 + 1;
  }
  let joeWidthTran = scaleTran(0, 20, createUpTransition(25, 45))
  $: joeWidth = joeWidthTran(progressJoe);

  // Housing market
  let marketTran = createUpDownTransition(10, 20, 90, 100);
  $: opacityMarket = marketTran(progressHousing);
  let yMarketCard1Tran = scaleTran(-120, 0, createUpDownTransition(20, 25, 38, 40));
  $: yMarketCard1 = yMarketCard1Tran(progressHousing);
  let yMarketCard2Tran = scaleTran(-120, 0, createUpDownTransition(35, 40, 48, 50));
  $: yMarketCard2 = yMarketCard2Tran(progressHousing);
  let yMarketCard3Tran = scaleTran(-120, 0, createUpDownTransition(45, 50, 78, 80));
  $: yMarketCard3 = yMarketCard3Tran(progressHousing);
  let yMarketCard4Tran = scaleTran(-120, 0, createUpDownTransition(75, 80, 90, 92));
  $: yMarketCard4 = yMarketCard4Tran(progressHousing);

  // Housing market phase
  let phaseHousingTran = createPhase([20, 30, 40, 50, 60, 65, 70, 75, 80, 90])
  $: phaseHousing = phaseHousingTran(progressHousing)

  // Tax group
  let taxGroupTran = createUpDownTransition(10, 20, 90, 100);
  $: opacityTaxGroup = taxGroupTran(progressTax);

  // Tax group phase
  let taxControlTopTran = scaleTran(-40, 30, createUpTransition(30, 35));
  $: taxControlTop = taxControlTopTran(progressTax);
  let taxControlHeightTran = scaleTran(50 * 0.75, 50, createUpTransition(70, 75));
  $: taxControlHeight = taxControlHeightTran(progressTax);
  $: sepTax = progressTax < 75 ? true : false;

  // Tax group cards
  let yTaxGroupCard1Tran = scaleTran(-120, 0, createUpDownTransition(20, 25, 33, 35));
  $: yTaxGroupCard1 = yTaxGroupCard1Tran(progressTax);
  let yTaxGroupCard2Tran = scaleTran(-120, 0, createUpDownTransition(30, 35, 58, 60));
  $: yTaxGroupCard2 = yTaxGroupCard2Tran(progressTax);
  let yTaxGroupCard3Tran = scaleTran(-120, 0, createUpDownTransition(55, 60, 73, 75));
  $: yTaxGroupCard3 = yTaxGroupCard3Tran(progressTax);
  let yTaxGroupCard4Tran = scaleTran(-120, 0, createUpDownTransition(70, 75, 90, 92));
  $: yTaxGroupCard4 = yTaxGroupCard4Tran(progressTax);

  // Tax group control variables
  let noninv = true;
  let inv = true;
  let rateNoninv = 0.01;
  let rateInv = 0.01;
  let rateBoth = 0.01;
  let taxThrd = 1000000;
  let sumInv = 0;
  let sumNoninv = 0;
  $: sum = sumInv + sumNoninv;

  // Changing tax threshold and rate
  let taxThrdTran = scaleTran(1000000, 2000000, createUpTransition(40, 45));
  $: taxThrd = taxThrdTran(progressTax);
  let rateTran = scaleTran(0.01, 0.02, createUpTransition(45, 50));
  $: rateBoth = rateTran(progressTax);

  // Backgroud
  $: alphaBg = 1 - opacityMarket - opacityTaxGroup;
  $: opacityBg = 0.3 * alphaBg;

  let zidxBg = 1;
  $: {
	if ((80 <= progressHousing && progressHousing < 100) ||
		(60 <= progressTax && progressTax < 100)) {
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
			opacity: {opacityBg}; z-index: {zidxBg};">
  <img src="/houses-dark.png" alt="houses-bg">
</div>

<div style="position: fixed; top: 0%; left: 0%; width: 100vw; height: 100vh;
			opacity: {opacityOpening}; z-index: {zidxBg};">
  <!-- <img src="/houses.png" alt="houses-color-bg"> -->
  <img src="/opening/frame-{openingFrame}.png" alt="opening">
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
  <div style="position: absolute; height: 60%; bottom: 20%; left: 0%;
			  transform: translateX({timX}%);">
	<img class="tim-intro" src="/tim-intro/walking-{walkingTim}.png" alt="tim">
  </div>
</div>

<div style="position: fixed; top: 0%; left: 0%; width: 100vw; height: 100vh;
			opacity: {opacityPeopleBlue}; z-index: {zidxBg};">
  <img src="/people-blue.png" alt="people-blue-bg">
</div>

<div style="position: fixed; top: 0%; left: 0%; width: 100vw; height: 100vh;
			opacity: {opacityJoe}; z-index: {zidxBg};">
  <div style="position: absolute; height: 60%; bottom: 20%; right: 20%;
			  width: {joeWidth}%; display: flex;">
	<img class="joe-intro"
		 src="/joe-intro/walking-{walkingJoe}.png" alt="joe">
  </div>
</div>

<div style="position: relative; color: white; background-color: rgb(0 0 0 / {alphaBg});">

  <!-- Opening -->
  <Scrolly bind:progress={progressOpening} threshold={0} margin={0} --scrolly-layout="overlap" >
	<div style="height: 180vh;" />
	<svelte:fragment slot="viz">
	</svelte:fragment>
  </Scrolly>

  <!-- Intro of Affordable Homes Act -->
  <div class="flexpage flex-col" style="height: 140vh;">
	<div style="flex: 1; height: 80vh;">
	  <img height="100%" src="/intro-1.png" alt="act">
	</div>
	<div style="flex: 1; font-size: 40px; height: 20vh; width: 80%;">
	  In 2023, Massachusetts published the Affordable Homes Acts, introducing the <tspan style="color: #EE7733;">transfer fee</tspan> to MA for the first time.
	</div>
  </div>

  <!-- Transfer fee -->
  <Scrolly bind:progress={progressAffordable} threshold={1} margin={0} --scrolly-layout="overlap" >
	<div class="relpage" style="height: 500vh;">
	  <div style="width: 80%; height: 100vh;
				  position: sticky; top: 5%; left: 10%;
				  font-size: 40px;
				  opacity: {opacityFee};">

		The Affordable Homes Act includes a provision that would grant
		Massachusetts municipalities the authority to implement a real estate
		transfer fee of
		<tspan style="color: #EE7733;">0.5% to 2.0%</tspan> on transactions of
		more than
		<tspan style="color: #EE7733;">$1M</tspan> or the county median single
		family home price, whichever is greater.<br><br>

		For instance, the transfer fee for a 2M property under the 2% rate is:<br>
		<center>(2M - 1M) × 0.02 = 10K $</center>
	  </div>

	  <div style="position: sticky; top: 40vh; width: 100%; height: 60vh;
				  opacity: {opacityBuilding};">
		<img src="/affordable/base.png" alt="act">
	  </div>

	  <div style="height: 80vh;" />

	  <div style="position: sticky; top: 62vh; left: 20vh; width: 30%;
				  opacity: {opacityBuilding};">
		<img src="/affordable/add-2.png" alt="act">
	  </div>

	  <div style="position: sticky; top: 56vh; left: 2vh; width: 20%;
				  opacity: {opacityBuilding};">
		<img src="/affordable/add-0.png" alt="act">
	  </div>

	  <div style="position: sticky; top: 45vh; left: 112vh; width: 20%;
				  opacity: {opacityBuilding};">
		<img src="/affordable/add-1.png" alt="act">
	  </div>

	  <div style="position: sticky; top: 55vh; left: 140vh; width: 30%;
				  opacity: {opacityBuilding};">
		<img src="/affordable/add-2.png" alt="act">
	  </div>

	  <div style="position: sticky; top: 49vh; left: 61vh; width: 22%;
				  opacity: {opacityBuilding};">
		<img src="/affordable/add-3.png" alt="act">
	  </div>

	  <div style="position: sticky; top: 60vh; left: 49vh; width: 18%;
				  opacity: {opacityBuilding};">
		<img src="/affordable/add-4.png" alt="act">
	  </div>

	  <div style="position: sticky; top: 50vh; left: 82vh; width: 18%;
				  opacity: {opacityBuilding};">
		<img src="/affordable/add-0.png" alt="act">
	  </div>

	  <div style="height: 100vh;" />
	</div>
  </Scrolly>

  <div style="position: fixed; width: 50%; bottom: 70%; left: 3%;
			  font-size: 36px;
			  z-index: {zidxBg};
			  opacity: {opacityAffordable};">
	According to the 2022 Greater Boston Area housing transaction data, it is
	preliminarily estimated that the implementation of this policy in 2023
	will generate <tspan style="color: #EE7733;">$208 million</tspan> in
	revenue for affordable housing.
  </div>

  <div style="position: fixed; width: 50%; top: 10%; right: 3%;
			  font-size: 60px;
			  z-index: {zidxBg};
			  opacity: {opacityAffordableCalc};">
	<center>
	  $208M ≈ 2000 units
	  <tspan style="font-size: 20px;">
		<br>(estimation based on
		<a href="https://www.boston.gov/sites/default/files/file/2022/04/Income%20Restricted%20Housing%20Report%2C%202021_0.pdf">
		  Income-Restricted Housing in Boston 2021)
		</a>
	  </tspan>
	</center>
  </div>

  <!-- Main question -->
  <Scrolly bind:progress={progressQuestion} threshold={1} margin={0} --scrolly-layout="overlap" >
	<div class="relpage" style="height: 250vh;">
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
	  <div style="position: absolute; width: 45%; height: 34%; top: 0%; left: 45%;
				  font-size: 25pt;">
		<center>-- Tim --</center><br>
		  
		An MIT architecture graduate and a
		<tspan style="color: {colortim};">first-time home buyer</tspan>, just
		got an offer in Boston with an annual household income around $100K. Tim
		is looking for a house in Boston with his family.
	  </div>
	</div>
	<div class="relpage" style="height: 80vh;">
	  <div style="position: absolute; width: 50%; height: 24%; bottom: 0%; left: 45%;
				  font-size: 25pt;">
		
		Ultimately, Tim plans to purchase a
		<tspan style="color: #EE7733;">$1.3M</tspan> house through a mortgage -
		which means he has to pay <tspan style="color: #EE7733;">$6K</tspan> as
		the transfer (assuming a 2% tax rate), almost one month of his salary.
	  </div>
	  <div style="position: absolute; height: 80%; left: 35%;">
		<img src="/condo.png" style="object-fit: contain;" alt="condo">
	  </div>
	</div>
	<div style="height: 100vh;" />
  </Scrolly>

  <!-- Joe -->
  <Scrolly bind:progress={progressJoe} threshold={1} margin={0} --scrolly-layout="overlap" >
	<div style="height: 100vh;" />
	<div class="relpage" style="height: 80vh;">
	  <div style="position: absolute; width: 50%; height: 34%; top: 0%; left: 5%;
				  font-size: 25pt;">
		<center> -- Joe -- </center><br>

		An agency from an investor company, looking for properties to invest in
		the Great Boston Area.
	  </div>
	</div>
	<div class="relpage" style="height: 80vh;">
	  <div style="position: absolute; width: 50%; height: 24%; bottom: 0%; left: 5%;
				  font-size: 25pt;">
		
		Let's take a look at what kinds of properties investors like and
		how much profit they can make in the housing market!
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
	<div style="height: 400vh;" />
	<svelte:fragment slot="viz">
	  <div class="text-dark" style="opacity: {opacityMarket};">
		<div style="position: absolute; height: 65%; width: 50%; left: 5%; top: 22%;">
		  <InvestorActivity phase={phaseHousing} {colortim} {colorjoe} />
		</div>
		<div style="position: absolute; height: 30%; width: 40%; right: 5%; bottom: 10%;">
		  <PriceHistogram color={colorjoe} seldata={seldatap} invsel={invselp} />
		</div>
		<div style="position: absolute; height: 25%; width: 20%; right: 0%; bottom: 20%;">
		  <InvestorPie id={0} color={colorjoe} data={seldatap} invsel={invselp} />
		</div>
		<div style="position: absolute; height: 30%; width: 40%; right: 5%; bottom: 50%;">
		  <PriceHistogram color={colortim} seldata={seldataq} invsel={invselq} />
		</div>
		<div style="position: absolute; height: 25%; width: 20%; right: 0%; bottom: 60%;">
		  <InvestorPie id={1} color={colortim} data={seldataq} invsel={invselq} />
		</div>
	  </div>
	</svelte:fragment>
  </Scrolly>

  <!-- Housing market cards -->
  <div class="card" style="transform: translateY({yMarketCard1}%);">
	<img class="lightbulb" src="/lightbulb.png" alt="lightbulb">
	<text>
	  Investors make ~2x profit as non-investors in the high-end (> $1M) housing market.
	</text>
  </div>

  <div class="card" style="transform: translateY({yMarketCard2}%);">
	<img class="lightbulb" src="/lightbulb.png" alt="lightbulb">
	<text>
	  This gap becomes even larger when it comes to flipped properties.
	</text>
  </div>

  <div class="card" style="transform: translateY({yMarketCard3}%);">
	<img class="lightbulb" src="/lightbulb.png" alt="lightbulb">
	<text>
	  Investors generally prefer the luxury housing markets.
	</text>
  </div>

  <div class="card" style="transform: translateY({yMarketCard4}%);">
	<img class="drag" src="/slider.gif" alt="slider">
	Select two markets and compare their revenue on your own!
  </div>

  <!-- Key result: Non-investors paying too much fee -->
  <div class="relpage" style="height: 100vh">
  	<div style="position: absolute; width: 40%; height: 40%; top: 35%; left: 29%;
				font-size: 25pt;">
	  <center>
		It seems that the
		<tspan style="color: {colortim};">non-investor home buyers</tspan>,
		represented by Tim, are paying a significant amount of transfer
		fees. <br><br>
		Meanwhile,
		<tspan style="color: cyan;">investors</tspan> are able to cover their
		transfer fee expenses through the much higher profits, potentially from
		flipping houses. Not to mention they still have priority trading rights
		in the housing market
		with <a href="https://homesforprofit.mapc.org/report#the-investor-advantage">cash offers</a>.
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

  <div class="flexpage textbox" style="font-size: 45px;">
	Now, let's dive into who's actually paying for the transfer fee!
  </div>


  <!-- Interactive visualization: Tax group breakdown -->
  <Scrolly bind:progress={progressTax} threshold={0.9} margin={innerHeight * 0.1} --scrolly-layout="overlap" >
	<div style="height: 400vh;" />
	<svelte:fragment slot="viz">
	  <div class="text-dark" style="position: absolute; top: 10%; height: 80vh; width: 65%; opacity: {opacityTaxGroup};">
		<TaxGroup
		  bind:sumNoninv bind:sumInv
		  {colortim} {colorjoe} {noninv} {inv} {rateNoninv} {rateInv} {taxThrd}
		  showtool={false} />
	  </div>
	  <div class="shaded"
		   style="position: fixed;
				  top: {taxControlTop}%;
				  right: 2%; height: {taxControlHeight}vh; width: 32%;
				  opacity: {opacityTaxGroup};">
	  </div>
	  <div class="text-dark"
		   style="position: fixed;
				  top: {taxControlTop}%;
				  right: 2%; height: 50vh; width: 32%;
				  opacity: {opacityTaxGroup};">
		<TaxControl
		  bind:noninv bind:inv bind:rateBoth bind:rateNoninv bind:rateInv bind:taxThrd bind:sepTax />
	  </div>
	  <div class="text-dark" style="position: fixed; bottom: 10%; right: 5%; opacity: {opacityTaxGroup}; font-size: {innerHeight * 0.04}px;">
		Total revenue: ${(sum / 1000000).toFixed(0)} M (
		<tspan style="color: {colortim};">{((sumNoninv / sum) * 100).toFixed(0)}%</tspan> /
		<tspan style="color: {colorjoe};">{((sumInv / sum) * 100).toFixed(0)}%</tspan>
		  )
	  </div>
	</svelte:fragment>
  </Scrolly>

  <!-- Tax group cards -->
  <div class="card" style="transform: translateY({yTaxGroupCard1}%);">
	<img class="lightbulb" src="/lightbulb.png" alt="lightbulb">
	Due to the large number of the non-investor home buyers, people like Tim,
	who purchase homes in the 1M-3M range, have become
	the primary group paying the transfer fee (31%).
  </div>
  <div class="card" style="transform: translateY({yTaxGroupCard2}%);">
	<img class="lightbulb" src="/lightbulb.png" alt="lightbulb">
	If the exemption threshold were increased to 2M, and the tax rate to 2%, the
	portion of non-investors would significantly reduce to 8% while maintaining
	the same level of revenue.
  </div>
  <div class="card" style="transform: translateY({yTaxGroupCard3}%);">
	<img class="slider" src="/slider.gif" alt="slider">
	Let's pretend we're the policy makers!  How would you adjust the policy to
	achieve a more equitable distribution of resources?
  </div>
  <div class="card" style="transform: translateY({yTaxGroupCard4}%);">
	<img class="slider" src="/slider.gif" alt="slider">
	<text>
	  How about a more fine-grained policy that collects different rates of
	  transfer fee from investors and non-investors?
	  (See <a href="https://homesforprofit.mapc.org/report#data-and-definitions">here</a>
	  for the definition of investors)
	</text>
  </div>

  <!-- Conclusions -->
  <div class="flexpage textbox" style="font-size: 42px;">
	The initial intent of this tool is to present some information more openly
	to the vast group of the non-investor home buyers, and it is also hoped to
	serve as one of the reference elements for government policy regulation.
  </div>
  <div class="flexpage textbox" style="font-size: 42px;">
  	Balancing the interests of multiple parties is very complex and faces
	many risks. With this tool, we hope that Boston's housing market can
	gradually move towards a more harmonious and fair state.
  </div>
  <div class="flexpage textbox" style="font-size: 45px;">
	<text>
	  This project was developed with guidance and feedback from the
	  <a href="https://www.mapc.org/">Metropolitan Area Planning Commission
		(MAPC)</a>.<br><br>

	  We are also grateful to the MIT Data & Society staffs and students that
	  provide valuable feedback.<br><br>

	  Data source: the Warren Group.
	</text>
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
	position: fixed;
	top: 0%;
	width: 100%;
	height: 8vh;
	box-sizing: border-box;
	background-color: white;
	display: flex;
	align-items: center;
	align-self: center;
	color: black;
    font-size: 36px;
	box-shadow: rgba(0, 0, 0, 0.6) 0px 25px 20px -20px;
	padding: 5%;
  }
  .shaded {
	border-radius: 25px;
	box-shadow: rgba(17, 17, 26, 0.1) 0px 4px 16px, rgba(17, 17, 26, 0.1) 0px 8px 24px, rgba(17, 17, 26, 0.1) 0px 16px 56px;
  }
  .lightbulb {
	width: 10vh;
	height: 10vh;
  }
  .slider {
	width: 10vh;
	height: 10vh;
  }
  .drag {
	width: 10vh;
	height: 10vh;
  }
  .tim-intro {
	height: 100%;
  }
  .joe-intro {
	height: 100%;
	object-fit: contain;
	transform: translate(50%, 0);
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
  a, a:hover, a:visited, a:active {
	color: inherit;
  }
</style>
