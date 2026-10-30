# Neovim v0.11.7 本机编译记录

- 日期：2026-10-30
- 主机：WSL2 / Ubuntu 26.04.1 / x86_64
- 源码：`neovim/neovim` 标签 `v0.11.7`，提交 `cd90ec7cdcdc55b617dfae5317b2c24b76b4148a`
- 构建类型：`Release`；使用 Neovim 自带的依赖构建流程
- 工具：GCC 15.2.0、CMake 4.2.3、Ninja 1.13.2
- 工具链与编译日志：`build/work/`（本地忽略目录）；解包的软件包版本见 [工具链清单](wsl-0.11.7-toolchain.txt)
- 安装目录：`dist/nvim-0.11.7-wsl-x86_64/`
- 压缩包：`dist/nvim-0.11.7-wsl-x86_64.tar.gz`
- 压缩包 SHA-256：`b7a2decaacfe913b91887e060db155607e9b6a629280a25045ebda8f07654b49`
- 二进制 SHA-256：`07e57680c54305984bbe4f23fdb349c9557409e7fa9055ee00e535e5e594c909`

## 实际检查

1. 依赖构建与 Neovim 本体编译成功。
2. 安装后的 `nvim --version` 输出 `NVIM v0.11.7`、`Build type: Release`。
3. `nvim --clean --headless` 成功执行 Lua 版本断言。
4. 压缩包解压到另一临时目录后，同一无界面启动检查通过。
5. 使用隔离的 XDG 数据目录启动仓库配置，Lazy 将锁文件中的 32 个插件全部标记为已加载；未发现 Lua 启动错误。
6. Neovim 基本编辑操作通过：在 buffer 写入两行、保存到文件、读回并比较内容。
7. Mason 安装了 `shfmt` v3.14.1 和 `stylua` 2.6.0。通过 Neovim 的 Conform 调用 Stylua 格式化临时 Lua 文件；`stylua --check` 与 `shfmt -d scripts/git-local` 均通过。
8. Tree-sitter 锁定提交的[插件说明](https://github.com/nvim-treesitter/nvim-treesitter/blob/7caec274fd19c12b55902a5b795100d21531391f/README.md)要求 Neovim 0.12.0+ 与 tree-sitter-cli 0.26.1+。本次二进制是 Neovim 0.11.7，因此虽能加载插件模块，Tree-sitter parser 安装和解析功能**不兼容/未验证**。

以上仅覆盖插件加载与基本编辑，不代表 LSP、补全、格式化、语法解析等功能全部可用。完整配置功能**未验证通过**。

本机二进制需要最高 `GLIBC_2.42` 符号版本，因此此产物只记录为本机 WSL 构建结果，**不用于 EL7**。Ubuntu 24.04 仍为**未验证目标**。

## 构建命令

源码位于 `build/work/neovim/`，用户目录工具链环境文件位于 `build/work/env.sh`。本次使用以下命令：

```bash
source build/work/env.sh
cmake -S build/work/neovim/cmake.deps -B build/work/neovim/.deps -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=gcc
cmake --build build/work/neovim/.deps --parallel 2
cmake -S build/work/neovim -B build/work/neovim/build -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=gcc -DCMAKE_INSTALL_PREFIX="$PWD/dist/nvim-0.11.7-wsl-x86_64"
cmake --build build/work/neovim/build --parallel 2
cmake --install build/work/neovim/build
```

工具链使用 Ubuntu 包解压到 `build/work/toolchain/`，因为当前会话没有免密 `sudo`。`build/work/`、`dist/` 都不提交到 Git。
