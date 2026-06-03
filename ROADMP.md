# Harzva AgentWorkOS Stack Roadmp

目标：把 `Harzva/harzva-agentworkos-stack` 从当前 Windows 机器的安全核心快照，升级为一个仓库、多平台 profile、可审计恢复的 Harzva AgentOS Stack。

## 使用规则

- `[x]` 只表示当前证据已经证明完成。
- `[ ]` 表示未完成、未验证、延期、阻塞或仍需用户输入。
- 不用计划替代完成证据。
- 涉及 runtime 写入的任务，必须先 dry-run，再决定是否 `--apply`。
- 平台差异优先进入 profile；机器私有差异进入 `agentworkos.local.toml`，不提交 GitHub。

## 安全规则

- 不提交 token、cookie、auth 文件、`.env`、credential dump。
- 不提交 raw chat logs、完整 memory store、transcript。
- 不在公开 manifest 中写入机器绝对路径。
- 不把 Windows/Mac/Linux 的配置拆成多个仓库，除非安全边界不同。
- 不把 runtime projection 当作唯一真源。

## 当前基线

- GitHub 仓库：`Harzva/harzva-agentworkos-stack`。
- Stack 工具：`Harzva/AgentWorkOS`。
- 当前默认 profile：`safe-core`。
- 当前 runtime 目标：Codex、Claude Code、AgentWorkOS cache/repo refs。
- 当前已发布内容：safe-core skills、agents、rules、terms、lockfile、Windows restore wrapper。
- 当前缺口：平台 profile 尚未明确表达 Windows/macOS/Linux/Linux server 的边界。

## Key Decisions

- 一个 Harzva stack 仓库承载多平台环境声明。
- `safe-core` 是跨平台公共基础层。
- `windows-desktop`、`mac-dev`、`linux-dev`、`linux-server` 是平台 profile。
- `linux2` 这类单机差异默认不建公开 profile，除非它代表稳定机器类别；否则写入 ignored local override。
- 公开仓库只记录 public-safe 能力；私有 repo、密钥、账号切换和本地路径进入本机私有配置。

## Overall Completion Standards

- `agentworkos.toml` 能表达通用层和平台层。
- `install.ps1` 支持新的 profile 名称。
- `README.md` 的首屏和恢复说明能解释 one-stack/multi-profile 模型。
- `ROADMP.md` 记录 roadmap 格式和升级阶段。
- `aw lock`、`aw doctor`、`aw install` dry-run 可通过。
- GitHub 远端包含最新 commit。

## Phases

### P0 - Roadmp 和平台 profile 建模

- [x] 新增 `ROADMP.md`，记录标准 roadmap 结构和证据规则。
  - Evidence: 2026-06-03 创建本文件。
- [x] 在 `agentworkos.toml` 增加 `windows-desktop`、`mac-dev`、`linux-dev`、`linux-server` profiles。
  - Evidence: 2026-06-03 manifest 增加平台 profile，均继承 `safe-core`。
- [x] 更新 `install.ps1` 的 profile 参数白名单。
  - Evidence: 2026-06-03 wrapper 支持新增平台 profile。
- [x] 更新 `README.md`，解释 one-stack/multi-profile 管理方式。
  - Evidence: 2026-06-03 README 增加 Platform profiles 和 Roadmp sections。

### P0.5 - 兼容 monorepo 收敛

- [x] 在 stack 仓库新增 `skills/*`，收敛当前 safe-core 依赖的 selected skills。
  - Evidence: 2026-06-04 copied selected skill source assets into `skills/` without `.git`, `node_modules`, build cache, or IDE cache folders。
- [x] 保持 package id 和 `install_to` 不变，仅把 selected skill source 切换为本仓库 local source。
  - Evidence: 2026-06-04 `agentworkos.toml` uses `source = "."` plus `path = "skills/<name>"` for vendored skills。
- [x] 更新 README 解释 monorepo mode 和 compatible-upgrade rule。
  - Evidence: 2026-06-04 README adds Monorepo mode section。
### P0.6 - Linux 一键升级入口

- [x] 根据 Linux 远端同步经验新增 `install.sh`。
  - Evidence: 2026-06-04 Linux run proved `aw --profile` works after updating `Harzva/AgentWorkOS`; sync applied to Codex and Claude runtime targets, then `aw scan` and `aw doctor` passed。
- [x] README 增加 One-command Linux upgrade，明确 dry-run 和 `--apply` 分离。
  - Evidence: 2026-06-04 README documents `bash ./install.sh --profile linux-dev --target all` and `--apply` flow。
- [x] 保留默认安全行为：不带 `--apply` 只 dry-run。
  - Evidence: 2026-06-04 `install.sh` defaults to dry-run and exits after preview unless `--apply` is present。
### P0.7 - GitHub npm wrapper

- [x] 增加 `package.json` 和 `bin/harzva-agentos.mjs`，支持 npm 从 GitHub 直接运行。
  - Evidence: 2026-06-04 `npx github:Harzva/harzva-agentworkos-stack --profile linux-dev --target all` documented as dry-run path。
- [x] npm wrapper 保持兼容：底层仍调用 `install.sh` 或 `install.ps1`。
  - Evidence: 2026-06-04 wrapper does not change `agentworkos.toml` package IDs, profiles, or runtime `install_to` targets。
- [x] 不发布到 npm 官方 registry。
  - Evidence: 2026-06-04 `package.json` is GitHub-installable and marked `private`。
### P1 - 平台能力扩展

- [ ] 为 `windows-desktop` 增加 public-safe Windows 专属技能或 repo 引用。
- [ ] 为 `mac-dev` 增加 public-safe macOS/iOS 开发能力。
- [ ] 为 `linux-dev` 增加 public-safe Linux CLI/dev 能力。
- [ ] 为 `linux-server` 增加 public-safe server/automation 能力。
- [ ] 明确哪些能力只能写入 `agentworkos.local.toml`。`r`n- [ ] 后续新 skill 默认先进入 stack monorepo，成熟到可独立复用时再拆出单仓库。

### P2 - 新机器恢复演练

- [ ] 在一台非 Windows 机器上执行 `aw install github:Harzva/harzva-agentworkos-stack --profile mac-dev --target all` dry-run。
- [x] 在 Linux 开发机执行 `--profile linux-dev` dry-run。`r`n  - Evidence: 2026-06-04 `docs/evidence/linux-sync-2026-06-04.md` records successful Linux dry-run/apply/scan/doctor summary。
- [ ] 在 Linux server 执行 `--profile linux-server` dry-run。
- [ ] 记录每个平台的缺失依赖、路径差异和 runtime projection 差异。`r`n- [x] 记录 Linux `linux-dev` 成功同步证据。`r`n  - Evidence: 2026-06-04 `docs/evidence/linux-sync-2026-06-04.md`。

### P3 - 三端同步治理

- [ ] 为 stack 仓库加入固定 release preflight checklist。
- [ ] 把 RepoAtlas map 作为私有或脱敏的迁移证据，不直接公开本机全路径。
- [ ] 设计 `agentworkos.local.toml.example`，只放 public-safe 示例，不放真实路径或账号。

## Test Plan

- `aw lock --manifest agentworkos.toml`
- `aw doctor --manifest agentworkos.toml --profile safe-core`
- `aw doctor --manifest agentworkos.toml --profile windows-desktop`
- `aw doctor --manifest agentworkos.toml --profile mac-dev`
- `aw doctor --manifest agentworkos.toml --profile linux-dev`
- `aw doctor --manifest agentworkos.toml --profile linux-server`
- `aw install github:Harzva/harzva-agentworkos-stack --target all --profile windows-desktop` dry-run
- tracked-file credential scan before push

## Assumptions

- 当前仓库保持 public。
- 当前升级只声明平台 profile，不把私有机器配置公开化。
- `linux2` 暂不作为公开 profile，除非后续证明它是稳定机器类别而不是单机差异。
- `safe-core` 继续作为跨平台默认基础层。
