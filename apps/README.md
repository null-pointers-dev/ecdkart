This folder is for applications. Create apps here, for example `apps/web` or `apps/api`.

Each app should have its own `package.json` and build scripts. Example:

```
apps/web/package.json
{
  "name": "web",
  "version": "0.0.0",
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "biome lint",
    "format": "biome format --write"
  }
}
```
