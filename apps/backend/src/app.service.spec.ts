import { Test, type TestingModule } from "@nestjs/testing";
import { beforeEach, describe, expect, it } from "vitest";
import { AppService } from "./app.service";

describe("AppService", () => {
	let service: AppService;

	beforeEach(async () => {
		const module: TestingModule = await Test.createTestingModule({
			providers: [AppService],
		}).compile();

		service = module.get<AppService>(AppService);
	});

	it("should be defined", () => {
		expect(service).toBeDefined();
	});

	describe("getHello", () => {
		it('should return "Hello from backend!"', () => {
			expect(service.getHello()).toBe("Hello from backend!");
		});
	});
});
