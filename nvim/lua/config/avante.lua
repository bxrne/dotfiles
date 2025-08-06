return {
	providers = {
		copilot = {
			endpoint = "https://api.githubcopilot.com",
			model = "gpt-4o-2024-05-13",
			proxy = nil,
			allow_insecure = false,
			timeout = 30000,
			extra_request_body = {
				temperature = 0,
				max_tokens = 4096,
			},
		},
	},
}