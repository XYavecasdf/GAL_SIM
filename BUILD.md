# GAL-SIM 桌面应用构建指南

本指南将帮助您将 GAL-SIM 打包成可在 Windows、macOS 或 Linux 上运行的独立桌面应用程序。

## 前置要求

### 必需软件

1. **Node.js** (v16 或更高版本)
   - 下载地址: https://nodejs.org/
   - 验证安装: `node --version`

2. **npm** (通常随 Node.js 一起安装)
   - 验证安装: `npm --version`

3. **Python** (3.8 或更高版本)
   - 下载地址: https://www.python.org/
   - 验证安装: `python --version` 或 `python3 --version`

### 系统特定要求

#### Windows
- Windows 7 或更高版本
- 如需构建 macOS 或 Linux 版本，建议使用 CI/CD 或虚拟机

#### macOS
- macOS 10.13 或更高版本
- Xcode Command Line Tools: `xcode-select --install`

#### Linux
- Ubuntu 18.04+ / Debian 9+ / Fedora 28+ 或其他现代 Linux 发行版
- 安装必需的依赖:
  ```bash
  # Ubuntu/Debian
  sudo apt-get install -y build-essential libssl-dev libffi-dev python3-dev
  
  # Fedora
  sudo dnf install -y gcc gcc-c++ make openssl-devel libffi-devel python3-devel
  ```

## 构建步骤

### 1. 克隆或下载项目

```bash
git clone https://github.com/XYavecasdf/GAL_SIM.git
cd GAL_SIM
```

### 2. 配置 Python 环境

首先需要在项目根目录创建 Python 虚拟环境并安装依赖：

```bash
# 创建虚拟环境
python -m venv venv

# 激活虚拟环境
# Windows:
venv\Scripts\activate
# macOS/Linux:
source venv/bin/activate

# 安装 Python 依赖
pip install -r requirements.txt
```

### 3. 配置环境变量

复制环境变量示例文件并配置：

```bash
cp .env.example .env
```

编辑 `.env` 文件，填入您的 LLM API 配置：

```env
LLM_API_KEY=your_api_key_here
LLM_BASE_URL=https://api.openai.com/v1
LLM_MODEL=gpt-3.5-turbo
```

### 4. 安装 Electron 依赖

进入 electron 目录并安装 Node.js 依赖：

```bash
cd electron
npm install
```

### 5. 测试开发模式

在构建前，建议先测试应用是否能正常运行：

```bash
# 确保在 electron 目录中
npm start
```

如果应用正常启动并显示界面，说明配置正确，可以继续构建。

### 6. 构建应用

根据目标平台选择相应的构建命令：

#### 构建当前平台版本

```bash
# 构建未打包版本（用于测试）
npm run build

# 构建完整安装包
npm run dist
```

#### 构建特定平台版本

```bash
# 构建 Windows 版本 (NSIS 安装包 + Portable 便携版)
npm run dist:win

# 构建 macOS 版本 (DMG 镜像)
npm run dist:mac

# 构建 Linux 版本 (AppImage + deb 包)
npm run dist:linux
```

#### 构建所有平台版本

```bash
# 注意：跨平台构建可能需要额外配置
npm run dist:all
```

### 7. 查找构建产物

构建完成后，安装包将位于 `electron/dist/` 目录中：

- **Windows**: 
  - `GAL-SIM Setup X.X.X.exe` (安装程序)
  - `GAL-SIM-X.X.X-portable.exe` (便携版)
  
- **macOS**: 
  - `GAL-SIM-X.X.X.dmg` (磁盘镜像)
  
- **Linux**: 
  - `GAL-SIM-X.X.X.AppImage` (AppImage 格式)
  - `gal-sim_X.X.X_amd64.deb` (Debian 包)

## 注意事项

### Python 运行时

打包后的应用**不包含** Python 运行时，用户需要在系统中安装 Python 3.8+ 并配置好环境变量。

为了让应用正常运行，最终用户需要：

1. 安装 Python 3.8 或更高版本
2. 将 Python 添加到系统 PATH
3. 安装应用所需的 Python 依赖包（应用首次运行时可以提示用户执行此操作）

### 跨平台构建

- 在 Windows 上构建 macOS/Linux 版本可能需要额外配置
- 在 macOS 上可以构建所有平台的版本（推荐）
- 在 Linux 上可以构建 Windows 和 Linux 版本
- 建议使用 CI/CD 服务（如 GitHub Actions）进行跨平台构建

### 代码签名

对于生产环境的应用，建议进行代码签名：

- **Windows**: 需要代码签名证书
- **macOS**: 需要 Apple Developer 账号和证书
- **Linux**: 通常不需要签名，但可以使用 GPG 签名

配置签名请参考 electron-builder 文档: https://www.electron.build/code-signing

## 故障排除

### 构建失败

1. **检查 Node.js 版本**: 确保使用 Node.js 16 或更高版本
2. **清理缓存**: 
   ```bash
   rm -rf node_modules
   npm install
   ```
3. **检查磁盘空间**: 构建过程需要较大的临时空间

### 应用无法启动

1. **检查 Python 安装**: 确保系统中安装了 Python 并在 PATH 中
2. **检查端口占用**: 确保端口 8000 未被占用
3. **查看日志**: 在开发者工具的控制台中查看错误信息

### 图标未显示

确保 `gal_sim/static/favicon.ico` 文件存在且格式正确。可以使用在线工具将图片转换为 .ico 格式。

## 进阶配置

### 自定义应用信息

编辑 `electron/electron-builder.json` 可以自定义：

- 应用名称和 ID
- 安装选项
- 图标路径
- 构建目标
- 文件包含/排除规则

### 自动更新

可以配置 electron-updater 实现自动更新功能。详见 electron-builder 文档。

## 参考资源

- electron-builder 文档: https://www.electron.build/
- Electron 官方文档: https://www.electronjs.org/docs/latest/
- GAL-SIM 项目主页: https://github.com/XYavecasdf/GAL_SIM

## 许可证

本项目使用 MIT 许可证。
