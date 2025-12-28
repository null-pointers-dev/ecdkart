import path from "node:path";
import { fileURLToPath } from "node:url";
import swc from "unplugin-swc";
import { defineConfig } from "vitest/config";

const __dirname = path.dirname(fileURLToPath(import.meta.url));

export default defineConfig({
	test: {
		environment: "node",
		globals: true,
		root: ".",
		exclude: ["node_modules", "dist", "**/*.e2e.ts"],
		include: ["src/**/*.{test,spec}.ts"],
		setupFiles: ["./vitest.setup.ts"],
		coverage: {
			provider: "v8",
			reporter: ["text", "json", "html", "lcov"],
			exclude: ["node_modules/", "dist/", "src/**/*.e2e.ts"],
		},
	},
	plugins: [swc.vite()],
	resolve: {
		alias: {
			"@": path.resolve(__dirname, "src"),
		},
	},
});
