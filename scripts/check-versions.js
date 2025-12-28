#!/usr/bin/env node

/**
 * Pre-install script to check Node.js and pnpm versions
 * This runs automatically before `pnpm install`
 */

const { engines } = require("../package.json");
const { execSync } = require("node:child_process");

const RED = "\x1b[31m";
const GREEN = "\x1b[32m";
const YELLOW = "\x1b[33m";
const RESET = "\x1b[0m";

function checkVersion(_name, current, required) {
	const currentParts = current.split(".").map(Number);
	const requiredParts = required.replace(">=", "").split(".").map(Number);

	for (let i = 0; i < requiredParts.length; i++) {
		if (currentParts[i] > requiredParts[i]) return true;
		if (currentParts[i] < requiredParts[i]) return false;
	}
	return true;
}

// Check Node.js version
const nodeVersion = process.version.slice(1);

console.log(`\n🔍 Checking versions...`);
console.log(`Node.js: ${nodeVersion} (required: ${engines.node})`);

if (!checkVersion("Node.js", nodeVersion, engines.node)) {
	console.error(`${RED}❌ Node.js version mismatch!${RESET}`);
	console.error(`\n${YELLOW}Required: ${engines.node}${RESET}`);
	console.error(`${YELLOW}Current:  v${nodeVersion}${RESET}\n`);
	console.error("Please use nvm or fnm to install the correct version:");
	console.error("  nvm use");
	console.error("  # or");
	console.error("  fnm use\n");
	process.exit(1);
}

// Check pnpm version (if available)
try {
	const pnpmVersion = execSync("pnpm --version", { encoding: "utf-8" }).trim();
	const requiredPnpm = engines.pnpm.replace(">=", "");

	console.log(`pnpm:    ${pnpmVersion} (required: ${engines.pnpm})`);

	if (!checkVersion("pnpm", pnpmVersion, engines.pnpm)) {
		console.error(`${RED}❌ pnpm version mismatch!${RESET}`);
		console.error(`\n${YELLOW}Required: ${engines.pnpm}${RESET}`);
		console.error(`${YELLOW}Current:  v${pnpmVersion}${RESET}\n`);
		console.error("Please update pnpm:");
		console.error("  corepack enable");
		console.error(`  corepack prepare pnpm@${requiredPnpm} --activate\n`);
		process.exit(1);
	}
} catch {
	// pnpm not found, but that's ok as npm might be used to install pnpm
}

console.log(`${GREEN}✅ Version check passed!${RESET}\n`);
