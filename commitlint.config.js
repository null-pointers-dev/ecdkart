module.exports = {
	extends: ["@commitlint/config-conventional"],
	rules: {
		"type-enum": [
			2,
			"always",
			[
				"feat", // A new feature
				"fix", // A bug fix
				"docs", // Documentation only changes
				"style", // Changes that don't affect code meaning
				"refactor", // Code change that neither fixes a bug nor adds a feature
				"perf", // Code change that improves performance
				"test", // Adding or updating tests
				"ci", // Changes to CI/CD configuration
				"chore", // Changes to build process, dependencies, etc.
				"revert", // Revert a previous commit
			],
		],
		"type-case": [2, "always", "lowercase"],
		"subject-case": [2, "never", ["start-case", "pascal-case", "upper-case"]],
		"subject-empty": [2, "never"],
		"subject-full-stop": [2, "never", "."],
		"body-leading-blank": [2, "always"],
		"footer-leading-blank": [2, "always"],
	},
};
