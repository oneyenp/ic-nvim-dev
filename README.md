# nvim-dev

Neovim 配置与 EL7 兼容发行包的开发仓库。配置以 [oneyenp/nvim-centos7](https://github.com/oneyenp/nvim-centos7) 的提交 `e67a9e90168b8b0f1dcfc77cc181dbf754a2347b` 为起点，后续分别整理 Neovim 二进制和插件的构建过程。

## 目标平台

| 平台 | 用途 | 验证状态 |
| --- | --- | --- |
| 当前 WSL2 / Ubuntu 26.04 x86_64 | 日常开发与运行 | Neovim 二进制已验证；完整配置待验证 |
| EL7 x86_64 | 构建基线与发行目标 | 待验证 |
| Ubuntu 24.04 x86_64 | 目标机器 | **未验证，当前不纳入实际验证** |

“目标机器”不等于“已验证支持”。发布说明必须分别列出实际测试过的平台、测试日期和测试产物。

## 目录

- `config/nvim/`：Neovim 配置和插件锁文件，直接作为 XDG 配置目录使用。
- `build/`：EL7 兼容 Neovim 二进制和发行包的构建定义。
- `plugins/`：插件离线打包、原生组件和外部工具的整理记录。
- `scripts/`：可复用的构建、检查和验证脚本。
- `docs/`：设计与兼容性记录。
- `dist/`：本地产物目录，内容不提交。

## 本地使用

当前工作区的 `.git/` 是只读挂载点。Git 元数据暂存于 `.git-local/.git/`；在此工作区请用 `scripts/git-local` 代替 `git`（例如 `scripts/git-local status`）。当工作区允许写入 `.git/` 时，可将 `.git-local/.git/` 中的元数据迁移到 `.git/`，恢复普通 Git 命令。

本机编译产物位于 `dist/nvim-0.11.7-wsl-x86_64/`，可先检查版本：

```bash
dist/nvim-0.11.7-wsl-x86_64/bin/nvim --version
```

使用仓库配置时，从仓库根目录运行：

```bash
XDG_CONFIG_HOME="$PWD/config" dist/nvim-0.11.7-wsl-x86_64/bin/nvim
```

首次启动时，参考配置的 `lazy.nvim` 引导逻辑可能联网下载插件。本次验证中 32 个插件模块已加载，基本编辑及 Conform 调用 Stylua 格式化通过；锁定的 `nvim-treesitter` 版本要求 Neovim 0.12，因此其解析功能未验证。构建结果和限制见 [本机 v0.11.7 构建记录](build/wsl-0.11.7.md)。后续离线发行包需要将配置、锁定版本的插件及其运行依赖一起打包，并在 WSL 与 EL7 分别实测。

## 参考实现

- [配置仓库](https://github.com/oneyenp/nvim-centos7)
- [EL7 Neovim 构建工作流](https://github.com/oneyenp/nvim-centos7/blob/main/.github/workflows/build-nvim.yml)
- [LazyVim 打包工作流](https://github.com/oneyenp/nvim-centos7/blob/main/.github/workflows/bundle-lazynvim-full.yaml)

参考工作流目前仅作设计输入；本仓库尚未实现或验证最终构建流程。
