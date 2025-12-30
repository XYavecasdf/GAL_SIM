const { app, BrowserWindow, ipcMain } = require('electron');
const path = require('path');
const isDev = require('electron-is-dev');
const { spawn, exec } = require('child_process');

let mainWindow;
let pythonProcess;
let serverReady = false;

function createWindow() {
  mainWindow = new BrowserWindow({
    width: 1200,
    height: 800,
    webPreferences: {
      nodeIntegration: false,
      contextIsolation: true,
      preload: path.join(__dirname, 'preload.js')
    },
    icon: path.join(__dirname, '../gal_sim/static/favicon.ico') // 使用项目中的favicon作为应用图标
  });

  // 在开发模式下使用本地服务器，生产模式下启动FastAPI服务器
  if (isDev) {
    mainWindow.loadURL('http://localhost:8000');
  } else {
    // 启动FastAPI服务器并等待其就绪
    startFastAPIServer().then(() => {
      mainWindow.loadURL('http://localhost:8000');
    }).catch((err) => {
      console.error('Failed to start FastAPI server:', err);
      mainWindow.loadURL('http://localhost:8000'); // 尝试连接，即使启动失败
    });
  }

  if (isDev) {
    mainWindow.webContents.openDevTools();
  }
}

// 启动FastAPI服务器
function startFastAPIServer() {
  return new Promise((resolve, reject) => {
    const resourcesPath = isDev 
      ? path.join(__dirname, '..') 
      : process.resourcesPath;
    
    const appPath = isDev
      ? path.join(__dirname, '../run_server.py')
      : path.join(resourcesPath, 'app/run_server.py');
    
    // 根据操作系统确定Python可执行文件路径
    let pythonCmd = 'python3';
    
    if (process.platform === 'win32') {
      pythonCmd = 'python';
    }
    
    const workingDir = isDev
      ? path.join(__dirname, '..')
      : path.join(resourcesPath, 'app');
    
    console.log('Starting FastAPI server...');
    console.log('Python command:', pythonCmd);
    console.log('App path:', appPath);
    console.log('Working directory:', workingDir);
    
    pythonProcess = spawn(pythonCmd, [appPath], {
      cwd: workingDir,
      env: {
        ...process.env,
        PYTHONUNBUFFERED: '1'
      }
    });

    pythonProcess.stdout.on('data', (data) => {
      const output = data.toString();
      console.log(`FastAPI: ${output}`);
      
      // 检测服务器是否已启动
      if (!serverReady && (output.includes('Uvicorn running on') || output.includes('Application startup complete'))) {
        serverReady = true;
        console.log('FastAPI server is ready');
        resolve();
      }
    });

    pythonProcess.stderr.on('data', (data) => {
      console.error(`FastAPI Error: ${data}`);
    });

    pythonProcess.on('close', (code) => {
      console.log(`FastAPI process exited with code ${code}`);
      if (!serverReady) {
        reject(new Error(`Server exited with code ${code} before becoming ready`));
      }
    });
    
    // 设置超时，防止无限等待
    setTimeout(() => {
      if (!serverReady) {
        console.warn('⚠️ Server startup timeout after 30 seconds');
        console.warn('   The server may still be starting. If the app does not load,');
        console.warn('   please check that Python and dependencies are properly installed.');
        resolve(); // 超时后仍然继续，而不是失败
      }
    }, 30000); // 30秒超时
  });
}

app.whenReady().then(() => {
  createWindow();

  app.on('activate', function () {
    if (BrowserWindow.getAllWindows().length === 0) createWindow();
  });
});

app.on('window-all-closed', function () {
  if (pythonProcess) {
    pythonProcess.kill();
  }
  if (process.platform !== 'darwin') app.quit();
});

app.on('quit', () => {
  if (pythonProcess) {
    pythonProcess.kill();
  }
});