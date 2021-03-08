<script>
	import { onMount } from "svelte";
	import shuffle from "shuffle-array";
	import moment from "moment";
	import "moment/locale/ja";

	let data = [];
	onMount(async () => {
		const res = await (await fetch("https://raw.githubusercontent.com/diamondcatpng/cross-internet/api/article.json")).json();
		data = shuffle(res, { copy: true });
	});

	async function ogp(url) {
		return await (await fetch("https://ricapitolare.vercel.app/?url=" + url)).json();
	}

	let scrollY;
	let windowHeight;
	let contentHeight;
	let loading = 0;

	setInterval(() => {
		if (loading < data.length && scrollY + windowHeight * 1.3 > contentHeight) {
			loading++;
			console.log(loading);
		}
	}, 100);
</script>

<svelte:window bind:innerHeight={windowHeight} bind:scrollY />

<svelte:head>
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/tailwindcss@2.0.3/dist/tailwind.min.css" media="print" onload="this.media='all'" />
</svelte:head>

<div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4" bind:offsetHeight={contentHeight}>
	{#each data as content, i}
		{#if i < loading}
			<a class="outline-none border hover:shadow-inner hover:bg-gray-100" href={content.url} target="_blank" rel="noopener noreferrer">
				<div class="h-full p-4 break-words">
					{#await ogp(content.url)}
						<p>読み込み中…</p>
					{:then ogp}
						<div class="h-full flex flex-col justify-between">
							<div>
								<img class="w-full md:w-40 mb-2 md:mb-0 md:float-right md:rounded-3xl" src="https://images.weserv.nl/?url={ogp.image}&w=512&output=webp" alt={ogp.title} />
								<h2 class="text-xl font-bold">{ogp.title}</h2>
								<p class="text-gray-600">{ogp.description}</p>
							</div>
							<div>
								<hr class="my-3" />
								<div class="flex items-center justify-between">
									<div class="flex">
										<img class="w-6 mx-1" src="https://images.weserv.nl/?url={ogp.icon}&output=webp" alt={ogp.provider} />
										<span>{ogp.provider}</span>
									</div>
									<div class="text-xs text-gray-600">
										<span>{content.traffic}</span>
										<span class="mx-1">&bull;</span>
										<span>{moment(content.date).fromNow()}</span>
									</div>
								</div>
							</div>
						</div>
					{:catch error}
						<p>{error}</p>
					{/await}
				</div>
			</a>
		{/if}
	{/each}
</div>
