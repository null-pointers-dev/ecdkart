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
		include: ["src/**/*.e2e.ts"],
		setupFiles: ["./vitest.setup.ts"],
		testTimeout: 30000,
	},
	plugins: [swc.vite()],
	resolve: {
		alias: {
			"@": path.resolve(__dirname, "src"),
		},
	},
});
