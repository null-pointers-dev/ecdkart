import { Test, type TestingModule } from "@nestjs/testing";
import { beforeEach, describe, expect, it } from "vitest";
import { AppController } from "./app.controller";
import { AppService } from "./app.service";

describe("AppController", () => {
	let controller: AppController;
	let _service: AppService;

	beforeEach(async () => {
		const module: TestingModule = await Test.createTestingModule({
			controllers: [AppController],
			providers: [AppService],
		}).compile();

		controller = module.get<AppController>(AppController);
		_service = module.get<AppService>(AppService);
	});

	it("should be defined", () => {
		expect(controller).toBeDefined();
	});

	describe("getHello", () => {
		it('should return "Hello from backend!"', () => {
			expect(controller.getHello()).toBe("Hello from backend!");
		});
	});
});
