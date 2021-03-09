<svelte:head>
	{#await fetch("https://api.github.com/orgs/cross-internet").then((r) => r.json()) then org}
		<title>{org.name}</title>
		<meta name="description" content={org.description} />
		<link rel="icon" type="image/png" href={org.avatar_url} />
	{/await}
</svelte:head>
