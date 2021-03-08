<script>
	import { onMount } from "svelte";

	let data = [];
	onMount(async () => {
		data = await (await fetch("https://raw.githubusercontent.com/diamondcatpng/cross-internet/api/article.json")).json();
	});

	async function sleep(ms) {
		await new Promise((x) => setTimeout(x, ms));
	}

	async function ogp(url) {
		return await (await fetch("https://ricapitolare.vercel.app/?url=" + url)).json();
	}
</script>

<div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4">
	{#each data as content, i}
		{#await sleep(i * 100) then _}
			<a class="outline-none border hover:shadow-inner hover:bg-gray-100" href={content.url} target="_blank">
				<div class="p-4 break-words">
					{#await ogp(content.url)}
						<p>読み込み中…</p>
					{:then ogp}
						<img class="w-full md:w-40 mb-2 md:mb-0 md:float-right md:rounded-3xl" src="https://images.weserv.nl/?url={ogp.image}&w=512&format=webp" alt={ogp.title} />
						<h2 class="text-xl font-bold">{ogp.title}</h2>
						<p class="text-gray-600">{ogp.description}</p>
					{/await}
				</div>
			</a>
		{/await}
	{/each}
</div>

<!-- <div
	class="h-screen overflow-y-scroll"
	on:mousewheel={() => console.log("a")}
>
		<div style="height: 1px;" />
	<div class="h-screen bg-green-400" />
		<div style="height: 1px;" />
</div> -->

<!-- <div class="grid md:grid-cols-2 xl:grid-cols-4">
	{#each data as content}
		{#await ogp(content.url)}
			<p>読み込み中…</p>
		{:then ogp}
			<div class="overflow-hidden break-words">
				<div class="m-4 border-2 rounded-lg hover:shadow-lg {content.live ? 'bg-red-300' : content.upcoming ? 'bg-green-300' : ''}">
					<a href={content.url} target="_blank" class="outline-none">
						<div class="p-4 flex justify-between">
							<div class="flex items-center">
								<img class="w-8" src="https://images.weserv.nl/?url={ogp.icon}&format=webp" alt={ogp.provider} />
								<p class="ml-4">{ogp.provider}</p>
							</div>
							{#if content.live || content.upcoming}
								<div class="flex items-center">
									<span class="text-xl font-semibold {content.live ? 'text-red-600' : content.upcoming ? 'text-green-600' : ''}">{content.live ? "ライブ" : content.upcoming ? "待機枠" : ""}</span>
								</div>
							{/if}
						</div>
						{#if ogp.image}
							<img class="w-full" src="https://images.weserv.nl/?url={ogp.image}&w=512&format=webp" alt={ogp.title} />
						{/if}
						<div class="px-6 py-4">
							<div class="mb-2 font-bold text-xl">{ogp.title}</div>
							{#if ogp.description}
								<p class="text-base text-gray-700">{ogp.description}</p>
							{/if}
						</div>
					</a>
				</div>
			</div>
		{/await}
	{/each}
</div> -->
