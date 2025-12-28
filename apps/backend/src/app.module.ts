import { AuthModule } from "@mguay/nestjs-better-auth";
import { Module } from "@nestjs/common";
import { ConfigModule } from "@nestjs/config";
import { betterAuth } from "better-auth/*";
import { drizzleAdapter } from "better-auth/adapters/drizzle";
import type { NodePgDatabase } from "drizzle-orm/node-postgres";
import { AppController } from "./app.controller";
import { AppService } from "./app.service";
import { DatabaseModule } from "./core/database/database.module";
import { DATABASE_CONNECTION } from "./core/database/database-connection";

@Module({
	imports: [
		ConfigModule.forRoot(),
		DatabaseModule,
		AuthModule.forRootAsync({
			useFactory: (database: NodePgDatabase) => ({
				auth: betterAuth({
					database: drizzleAdapter(database, {
						provider: "pg",
					}),
					emailAndPassword: {
						enabled: true,
					},
					trustedOrigins: ["http://localhost:3001"],
				}),
			}),
			inject: [DATABASE_CONNECTION],
		}),
	],
	controllers: [AppController],
	providers: [AppService],
})
export class AppModule {}
