<!-- Minimal technical README template. Use for infra, devtools, CLIs, and libraries that should feel precise. -->

# logcut

Small CLI for cutting large logs into reproducible, shareable debugging slices.

```text
raw log -> time/window filters -> compact artifact
```

## Install

```bash
cargo install logcut
```

## Usage

```bash
logcut app.log --since 10m --grep "payment" --out payment-debug.log
```

## Design Goals

- Produce artifacts small enough to attach to issues.
- Keep filtering rules explicit and repeatable.
- Avoid hidden state, background services, and proprietary storage.

## Non-Goals

- Full observability platform.
- Real-time log streaming.

## Configuration

| Option | Default | Description |
| --- | --- | --- |
| `--since` | none | Relative or absolute start time |
| `--grep` | none | Include lines matching a pattern |
| `--context` | `2` | Lines before and after a match |

## Internals

```mermaid
flowchart LR
    A["Read stream"] --> B["Apply filters"]
    B --> C["Preserve context"]
    C --> D["Write artifact"]
```

## License

MIT
