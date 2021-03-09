<script>
    import moment from "moment";
    import "moment/locale/ja";
    export let url;
    export let traffic;
    export let date;
</script>

{#await fetch("https://ricapitolare.vercel.app/?url=" + url).then((r) => r.json())}
    <p>読み込み中…</p>
{:then data}
    <a class="outline-none" href={url} target="_blank" rel="noopener noreferrer">
        <div class="rounded-xl overflow-hidden border-2 hover:shadow-md">
            <img class="w-full" src="https://images.weserv.nl/?url={data.image}&w=512&output=webp" alt={data.title} />
            <div class="p-4">
                <p class="text-xl font-semibold">{data.title}</p>
                <p class="mt-3 text-sm text-gray-600">{data.description}</p>
                <hr class="my-3" />
                <div class="flex justify-between text-xs text-gray-600">
                    <div class="flex items-center">
                        <img width="16" height="16" src="https://images.weserv.nl/?url={data.icon}&w=16&h=16&output=webp" alt={data.provider} />
                        <span class="ml-1">{data.provider}</span>
                    </div>
                    <div>
                        <span>{traffic}</span>
                        <span class="mx-1">&bull;</span>
                        <span>{moment(date).fromNow()}</span>
                    </div>
                </div>
            </div>
        </div>
    </a>
{:catch error}
    <p>{url}</p>
    <p>{error}</p>
{/await}
