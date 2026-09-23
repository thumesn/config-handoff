# Conda 环境规则 / Conda Environment Rules

本文件描述在 `/home/chaofeng` 下工作时，AI agent 使用 Python 及相关工具时的 Conda 环境约定。AGENTS.md 中只给出简要提醒，详细规则以本文件为准。

## 1) 何时需要关注 Conda 环境
- 当任务涉及 Python 代码运行、训练/推理、Jupyter、Web/服务端程序等时，必须先确认当前激活的 Conda 环境。
- 仅进行纯文档编辑或与运行环境完全无关的操作时，可忽略 Conda 环境。

## 2) 推荐环境选择 / Recommended Environments
- PyTorch 或其他深度学习训练 / 推理：
  - 优先在 `torch` 环境中执行。
  - 示例：`conda activate torch`
- 启动 / 开发服务器或运行论文相关服务：
  - 优先在 `paper-env` 环境中执行。
  - 示例：`conda activate paper-env`
- 其他不确定的情况：
  - 如不确定应使用哪个环境，在回复中说明不确定，并询问用户建议，避免自行猜测。

## 3) 环境切换行为 / Switching Environments
- 允许 agent 在需要时自行激活合适的 Conda 环境。
- 在切换前，必须在回复中简要说明：
  - 将要激活的环境名称（例如：`torch`、`paper-env`）。
  - 切换原因（例如：“进行 PyTorch 推理”、“启动论文相关服务”）。
- 推荐说明示例：

```text
准备运行 PyTorch 推理代码，我会激活 `torch` 环境（conda activate torch），仅读取和运行现有脚本，不修改环境依赖。
```

## 4) 禁止在未授权情况下修改环境 / No Environment Modifications Without Approval
- 禁止在未经用户明确同意的情况下修改任何 Conda 环境，包括但不限于：
  - `conda install ...`
  - `pip install ...`
  - `conda remove ...` / `pip uninstall ...`
  - 升级 Python 版本或已有依赖包。
- 如确实需要安装新依赖或修改环境：
  - 在回复中清楚说明：
    - 为什么需要修改环境；
    - 计划执行的具体命令；
    - 可能影响的范围。
  - 明确请求用户确认，获得同意后再执行相应命令。

## 5) 与 AGENTS.md 的关系 / Relation to AGENTS.md
- `AGENTS.md` 中只包含 “使用 Python 时需要考虑 Conda 环境” 的简要提示。
- 需要详细规则或更新 Conda 行为约定时，请直接编辑本文件，并在 `AGENTS.md` 中保持路径和说明一致。

