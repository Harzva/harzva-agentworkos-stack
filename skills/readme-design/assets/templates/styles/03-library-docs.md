<!-- Library/tool README template. Keep the top half short and runnable. -->

<div align="center">
  <!-- Optional: <img src="./docs/readme-assets/logo.svg" alt="typed-cache logo" width="220" /> -->
  <h1>typed-cache</h1>
  <p><strong>A tiny typed cache layer for Node.js services that need predictable expiry and testable storage.</strong></p>
  <p>
    <img src="https://img.shields.io/badge/npm-v0.4.0-DC2626" alt="npm version" />
    <img src="https://img.shields.io/badge/build-passing-10A37F" alt="build" />
    <img src="https://img.shields.io/badge/license-MIT-111827" alt="license" />
  </p>
</div>

## Install

```bash
npm install typed-cache
```

## 30-Second Example

```ts
import { createCache } from "typed-cache";

const cache = createCache<{ user: { id: string; name: string } }>({
  ttl: "10m",
});

await cache.set("user", { id: "42", name: "Ada" });
const user = await cache.get("user");
```

## API

| API | Description |
| --- | --- |
| `createCache(options)` | Create a typed cache instance |
| `cache.get(key)` | Read a value or return `undefined` |
| `cache.set(key, value)` | Store a value with configured expiry |
| `cache.delete(key)` | Remove a value |

## Design Goals

- Predictable expiry semantics.
- Small API surface.
- Easy unit testing with in-memory storage.

## Compatibility

| Runtime | Supported |
| --- | --- |
| Node.js | 18+ |
| Browser | Planned |
| Edge runtimes | Experimental |
