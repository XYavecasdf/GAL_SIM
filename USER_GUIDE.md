# GAL-SIM 用户使用指南

本指南适用于下载了 GAL-SIM 桌面应用程序的用户。

## 系统要求

### Windows
- Windows 7 或更高版本
- Python 3.8 或更高版本
- 至少 200MB 可用磁盘空间

### macOS
- macOS 10.13 (High Sierra) 或更高版本
- Python 3.8 或更高版本
- 至少 200MB 可用磁盘空间

### Linux
- Ubuntu 18.04+ / Debian 9+ / Fedora 28+ 或其他现代 Linux 发行版
- Python 3.8 或更高版本
- 至少 200MB 可用磁盘空间

## 安装 Python

GAL-SIM 需要 Python 运行时环境。如果您的系统尚未安装 Python，请按照以下步骤操作：

### Windows

1. 访问 https://www.python.org/downloads/
2. 下载 Python 3.8 或更高版本的安装程序
3. **重要**: 运行安装程序时，勾选 "Add Python to PATH" 选项
4. 点击 "Install Now" 完成安装
5. 验证安装：打开命令提示符，输入 `python --version`

### macOS

macOS 通常预装了 Python，但版本可能较旧。建议安装最新版本：

```bash
# 使用 Homebrew 安装（推荐）
brew install python3

# 或从官网下载安装包
# 访问 https://www.python.org/downloads/macos/
```

验证安装：
```bash
python3 --version
```

### Linux

大多数 Linux 发行版预装了 Python 3。如果没有，请使用包管理器安装：

```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install python3 python3-pip python3-venv

# Fedora
sudo dnf install python3 python3-pip

# Arch Linux
sudo pacman -S python python-pip
```

验证安装：
```bash
python3 --version
```

## 安装 Python 依赖

GAL-SIM 需要一些 Python 库才能运行。首次使用前，您需要安装这些依赖。

### 方法 1: 自动安装（推荐）

应用首次启动时会自动检测并提示安装依赖（如果应用实现了此功能）。

### 方法 2: 手动安装

1. 打开终端/命令提示符
2. 导航到应用安装目录
3. 执行以下命令：

**Windows:**
```cmd
cd resources\app
python -m pip install -r requirements.txt
```

**macOS/Linux:**
```bash
cd resources/app
python3 -m pip install -r requirements.txt
```

## 配置 API 密钥

GAL-SIM 需要连接到 LLM API 才能生成对话内容。

1. 在应用安装目录的 `resources/app/` 文件夹中找到 `.env.example` 文件
2. 复制该文件并重命名为 `.env`
3. 使用文本编辑器打开 `.env` 文件
4. 填入您的 API 配置：

```env
LLM_API_KEY=your_api_key_here
LLM_BASE_URL=https://api.openai.com/v1
LLM_MODEL=gpt-3.5-turbo
```

**重要说明:**
- `LLM_API_KEY`: 必填，您的 LLM API 密钥
- `LLM_BASE_URL`: 可选，API 端点地址（默认为 OpenAI）
- `LLM_MODEL`: 可选，使用的模型名称

### 推荐的 API 提供商

- OpenAI: https://platform.openai.com/
- LongCat: [推荐] 兼容 OpenAI 格式
- 其他兼容 OpenAI API 格式的服务

## 启动应用

### Windows

1. 双击 `GAL-SIM.exe`（如使用便携版）
2. 或从开始菜单启动（如使用安装版）
3. 应用会自动启动后端服务并打开主界面

### macOS

1. 打开 Applications 文件夹
2. 双击 GAL-SIM 应用图标
3. 首次运行可能需要在"系统偏好设置"中允许运行

### Linux

#### AppImage 方式
```bash
chmod +x GAL-SIM-*.AppImage
./GAL-SIM-*.AppImage
```

#### deb 包方式
```bash
sudo dpkg -i gal-sim_*.deb
# 从应用菜单启动，或命令行运行：
gal-sim
```

## 使用指南

1. **启动应用** - 等待应用加载（可能需要几秒钟启动后端服务）

2. **选择主题** 
   - 点击"自动生成主题"让 AI 为您生成一个随机主题
   - 或点击"自定义主题"输入您想要的故事背景（推荐）

3. **开始对话**
   - 点击"开始对话"按钮
   - AI 会生成开场白和初始场景

4. **进行选择**
   - 阅读 AI 生成的对话内容
   - 从提供的 A、B、C、D 四个选项中选择一个
   - 每个选项会导向不同的故事发展

5. **继续游戏**
   - 根据您的选择，故事会不断发展
   - 重复选择过程，体验不同的剧情走向

## 常见问题

### Q: 应用启动后一直显示加载中？

**A:** 可能的原因：
1. Python 依赖未安装 - 请参考"安装 Python 依赖"章节
2. 端口 8000 被占用 - 关闭占用该端口的其他程序
3. API 密钥未配置或错误 - 检查 `.env` 文件配置

### Q: 提示 Python 未找到？

**A:** 
1. 确保已安装 Python 3.8+
2. 确保 Python 已添加到系统 PATH
3. Windows 用户：重新安装 Python 时勾选 "Add Python to PATH"

### Q: API 请求失败？

**A:**
1. 检查 API 密钥是否正确
2. 检查网络连接
3. 确认 API 余额充足
4. 检查 `LLM_BASE_URL` 是否正确

### Q: macOS 提示"无法打开应用，因为它来自身份不明的开发者"？

**A:**
1. 打开"系统偏好设置" > "安全性与隐私"
2. 点击"仍要打开"按钮
3. 或使用命令行：`xattr -cr /Applications/GAL-SIM.app`

### Q: Linux 下 AppImage 无法运行？

**A:**
1. 确保文件有执行权限：`chmod +x GAL-SIM-*.AppImage`
2. 安装 FUSE：`sudo apt-get install fuse libfuse2`（Ubuntu/Debian）

### Q: 如何更新应用？

**A:**
下载新版本并覆盖安装。您的配置文件（`.env`）通常会保留。

### Q: 如何卸载应用？

**A:**
- **Windows**: 通过"添加或删除程序"卸载，或直接删除应用文件夹（便携版）
- **macOS**: 将应用拖到废纸篓
- **Linux**: `sudo apt-get remove gal-sim`（deb 包）或直接删除 AppImage 文件

## 数据和隐私

- GAL-SIM 不会收集或上传您的个人数据
- 所有对话内容仅发送到您配置的 LLM API 服务
- 会话数据保存在本地应用目录中

## 获取帮助

如果遇到问题：

1. 查看应用日志（通常在应用目录或系统日志中）
2. 访问项目 GitHub 页面提交 Issue: https://github.com/XYavecasdf/GAL_SIM
3. 查看项目 README 和 BUILD.md 文档

## 许可证

GAL-SIM 使用 MIT 许可证。详见 LICENSE 文件。
