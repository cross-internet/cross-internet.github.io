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

	async function ogp(url, ms) {
		await new Promise((x) => setTimeout(x, ms));
		return await (await fetch("https://ricapitolare.vercel.app/?url=" + url)).json();
	}
</script>

<div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4">
	{#each data as content, i}
		<a class="outline-none border hover:shadow-inner hover:bg-gray-100" href={content.url} target="_blank">
			<div class="h-full p-4 break-words">
				{#await ogp(content.url, i * 200)}
					<p>読み込み中…</p>
				{:then ogp}
					<div class="h-full flex flex-col justify-between">
						<div>
							<img class="w-full md:w-40 mb-2 md:mb-0 md:float-right md:rounded-3xl" src="https://images.weserv.nl/?url={ogp.image}&w=512&format=webp" alt={ogp.title} />
							<h2 class="text-xl font-bold">{ogp.title}</h2>
							<p class="text-gray-600">{ogp.description}</p>
						</div>
						<div>
							<hr class="my-3" />
							<div class="flex items-center justify-between">
								<div class="flex">
									<img class="w-6 mx-1" src="https://images.weserv.nl/?url={ogp.icon}&format=webp" alt={ogp.provider} />
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
				{/await}
			</div>
		</a>
	{/each}
</div>
