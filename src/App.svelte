<script>
	import { onMount } from "svelte";
	import arrayShuffle from "array-shuffle";
	import Head from "./Head.svelte";
	import Card from "./Card.svelte";

	let json = [];

	onMount(async () => {
		const r = await fetch("https://raw.githubusercontent.com/cross-internet/api/main/public/v2.json");
		json = await r.json();
	});

	let random = true;
	$: data = random ? arrayShuffle(json) : json;
	let alternative = false;

	let buf = 20;
	let now = 0;
	let box;
	$: if (box && box.scrollTop > (box.scrollHeight - box.clientHeight) * 0.9) {
		now++;
		console.log(now);
	}
</script>

<Head />

<div class="h-screen flex flex-col">
	<div class="py-6 flex justify-evenly" on:change={() => ((now = 0), (box = undefined))}>
		<label>
			<input type="checkbox" bind:checked={random} />
			<span>ランダム</span>
		</label>
		<label>
			<input type="checkbox" bind:checked={alternative} />
			<span>代替ページ (β版)</span>
		</label>
	</div>

	<div class="h-full overflow-y-scroll p-4 grid gap-4 grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 2xl:grid-cols-5" on:scroll={(e) => (box = e.currentTarget)}>
		{#each data as content, i}
			<div class="break-words">
				{#if i < (now + 1) * buf}
					<Card url={alternative && content.alternative_url ? content.alternative_url : content.url} traffic={content.traffic} date={content.date} />
				{/if}
			</div>
		{/each}
	</div>
</div>

<style global lang="postcss">
	@tailwind base;
	@tailwind components;
	@tailwind utilities;
</style>
