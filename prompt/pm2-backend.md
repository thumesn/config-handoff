# 后端服务与 pm2 规则 / Backend Services with pm2

本文件描述在 `/home/chaofeng` 下工作时，AI agent 启动和管理后端服务时使用 `pm2` 的约定。AGENTS.md 中只给出简要提醒，具体规则与更新以本文件为准。

## 1) 何时使用 pm2 / When to Use pm2

- 当需要启动长期运行的后端服务（如 Web API、dashboard、论文相关服务等）时，应优先使用 `pm2` 管理，而不是直接在前台运行命令。
- 一次性脚本或短时间运行的任务，仍然按普通命令或 tmux 规则处理，不必纳入 pm2。

## 2) 启动规则 / Start Rules

- 使用 `pm2 start` 启动后端服务，并指定清晰的进程名称，便于后续查看与管理。
- 典型模式（示例）：

```bash
pm2 start "<YOUR_COMMAND>" --name "<service-name>"
```

示例说明（命令仅作格式参考）：
- `pm2 start "python app.py" --name backend-api`
- `pm2 start "uvicorn main:app --host 0.0.0.0 --port 8000" --name paper-server`

要求：
- 进程名应能看出用途（如 `backend-api`、`paper-server`），避免使用无意义名称。
- 启动前，如涉及 Python / GPU，请先遵守 `prompt/conda-env.md` 和 `prompt/tmux-jobs.md` 中的环境与资源选择规则。

## 3) 查看与管理日志 / Logs and Management

- 查看整体进程列表：

```bash
pm2 list
```

- 查看某个服务的实时日志：

```bash
pm2 logs <service-name>
```

- 查看最近若干行日志（示例）：

```bash
pm2 logs <service-name> --lines 200
```

行为约定：
- 当用户询问后端运行状态或错误时，应优先通过 `pm2 logs` 查看并摘取关键片段，而不是直接读取零散日志文件。
- 在回复中说明：
  - 使用的 pm2 进程名；
  - 日志中观察到的关键现象（如启动成功、端口、错误堆栈等）。

## 4) 端口规则 / Port Rules

- 绑定端口前先检查目标端口是否已被占用，例如 `ss -tln | grep ':<port>'` 或 `lsof -i :<port>`。
- 选端口顺序：
  1. 项目文档或既有配置中明确指定的端口；
  2. 开发服务默认用 `8000–8999` 区间（前端 dev server 沿用其框架默认，如 Vite `5173`、Next `3000`，但要先确认未被占用）；
  3. 临时或测试服务用 `9000+`，用完即释放。
- 避免占用系统与其他服务常用端口（如 `80`、`443`、`5432`、`6379`、`11434` 及局域网代理端口 `10808/10809`），除非任务明确要求。
- 目标端口被占用时：
  - 优先为当前服务换一个未占用端口；
  - 不要自行 `kill`/`pm2 delete` 占用方进程释放端口，除非确认是本次任务要重启的同一个服务；
  - 占用方身份不明时，先向用户说明再处理。
- 启动后必须在回复中写明进程名和实际绑定的端口；若服务端口发生变更，应同步更新项目文档中的旧端口引用，并在 `logs/results/` 条目中记录。

## 5) 停止与重启 / Stop and Restart

- 停止服务：

```bash
pm2 stop <service-name>
```

- 重启服务：

```bash
pm2 restart <service-name>
```

在停止或重启前，应在回复中说明原因（例如更新配置、重新加载代码）并确认是否会影响当前实验或用户使用。

## 6) 与 tmux、Conda 的关系 / Relation to tmux and Conda

- pm2 主要用于管理**长期运行的后端服务**；tmux 更适合一次性长任务（如训练、批量推理），两者各司其职。
- 启动 pm2 服务前，若需要特定 conda 环境，应先在该环境中执行 `pm2 start` 命令。
- 对于既需要 GPU 又长期运行的服务，仍需遵守：
  - 先确认 GPU 负载，选择合适的卡； 
  - 在回复中说明选择的 GPU 与原因；
  - 再通过 pm2 启动服务。

## 7) 与 AGENTS.md 的关系 / Relation to AGENTS.md

- `AGENTS.md` 只强调：后端服务应通过 pm2 启动与查看日志。
- 本文件 `prompt/pm2-backend.md` 提供完整的 pm2 使用规则；如与 `AGENTS.md` 存在不一致，以本文件为准。
