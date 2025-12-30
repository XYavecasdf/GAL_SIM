# GAL_SIM - Galgame对话模拟器

## About

GAL_SIM 是一个基于Python和FastAPI的Galgame对话模拟项目，通过接入LLM API来生成剧情和角色对话，每次生成ABCD四个选项供用户选择。

现已支持打包成 **独立的桌面应用程序**，可在 Windows、macOS 和 Linux 上运行！

## Features

- 用户可以选择自动生成主题或自定义主题
- 通过API接入符合OpenAI规范的LLM进行对话生成
- 每次对话后提供四个选项供用户选择
- 支持会话管理，保持对话历史
- 响应式Web界面
- **支持打包成桌面应用程序**

## Enviromental requirements

- Python 3.8+
- 符合OpenAI的API规范的LLM的api-key(推荐LongCat)
- Node.js 16+ (如需构建桌面应用)

## Installation

1. 克隆项目：
   ```bash
   git clone https://github.com/notvalid0/GAL_SIM
   cd GAL_SIM
   ```

2. 创建虚拟环境并安装依赖：
   ```bash
   python -m venv venv
   source venv/bin/activate  # Linux/Mac
   # 或
   venv\Scripts\activate  # Windows
   
   pip install --break-system-packages -r requirements.txt  # For Linux Sys
   pip install -r requirements.txt  # Other OS
   ```

3. 配置API密钥：
   ```bash
   cp .env.example .env
   ```
   
   编辑 `.env` 文件，填入你的LLM API密钥：
   ```env
   LLM_API_KEY=your_api_key_here
   LLM_BASE_URL=https://api.openai.com/v1  # 可选，自定义endpoint
   LLM_MODEL=gpt-3.5-turbo  # 可选，模型名称
   ```
> ⚠️Note: 需要注意，endpoint与模型名称需要查询相应模型官方API文档

## 启动应用

### Web 模式

```bash
# 激活虚拟环境
source venv/bin/activate

# 启动应用
python -m uvicorn gal_sim.main:app --host 0.0.0.0 --port 8080
```

或使用启动脚本：

```bash
python run_server.py
```

应用将在 `http://localhost:8080` 上运行。

### 桌面应用模式

使用 Electron 启动桌面应用：

```bash
# 运行启动脚本
./start_electron.sh

# 或手动启动
cd electron
npm install
npm start
```

## 构建桌面应用程序

要将应用打包成可独立运行的桌面应用程序，请参阅 [BUILD.md](BUILD.md) 详细构建指南。

### 快速构建

```bash
# 安装 Electron 依赖
cd electron
npm install

# 构建当前平台的安装包
npm run dist

# 或构建特定平台
npm run dist:win    # Windows
npm run dist:mac    # macOS
npm run dist:linux  # Linux
```

构建产物将位于 `electron/dist/` 目录。

## API

- `POST /api/v1/start` - 开始新对话
- `POST /api/v1/dialogue` - 继续对话
- `GET /api/v1/session/{session_id}` - 获取会话信息

## How To Use

1. 访问 `http://localhost:8000`
2. 选择"自动生成主题"或"自定义主题(**推荐**)"
3. 点击"开始对话"
4. 查看角色的开场白和选项
5. 选择一个选项继续对话

## Custom Settings

### Custom Configuration

- 在 `.env` 文件中配置LLM API相关信息
- 修改 `static/css/style.css` 自定义样式
- 修改 `templates/index.html` 自定义前端界面

### Custom Favicon

要配置应用的 favicon.ico：

1. 创建一个 16x16 或 32x32 像素的图标文件（支持PNG、JPG或ICO格式）
2. 将图标转换为 .ico 格式（可以使用在线转换工具）
3. 将生成的 favicon.ico 文件替换 `gal_sim/static/favicon.ico`
4. 重启应用以使更改生效

## CHANGELOG

### V1.0.0
   满足基本需求，可以与AI对话

### V1.0.1
   新增好感度机制(不完善)

### V1.0.2
   接入背景图片API(默认为loliapi(质量较高而且自适应UA))

