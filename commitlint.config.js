/* Note: Install using pnpm add -D @commitlint/config-conventional */
module.exports = {
	extends: ["@commitlint/config-conventional"],
	rules: {
		"header-max-length": [2, "always", 100],
		"type-enum": [
			2,
			"always",
			[
				"feat",
				"fix",
				"docs",
				"style",
				"refactor",
				"perf",
				"test",
				"build",
				"ci",
				"chore",
				"revert",
				"infra",     // for infrastructure changes
				"security",  // for security updates
				"resource"   // for resource modifications
			],
		],
	},
};
