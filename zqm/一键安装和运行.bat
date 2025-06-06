@echo off
chcp 65001 >nul
title 银行股票分析报表生成器 - 一键安装和运行

echo.
echo ================================================
echo        银行股票分析报表生成器
echo             一键安装和运行
echo ================================================
echo.

echo 📋 系统环境检查和自动安装脚本
echo.
echo 🎯 本脚本将自动完成以下操作:
echo    1. 检查Python环境
echo    2. 检查并按需升级pip
echo    3. 智能安装所需依赖包
echo    4. 启动银行报表生成器
echo.

pause

echo.
echo ============== 第1步: 检查Python环境 ==============
echo.

python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 未检测到Python环境！
    echo.
    echo 📥 请先安装Python 3.7或更高版本:
    echo    下载地址: https://www.python.org/downloads/
    echo.
    echo 💡 安装建议:
    echo    - 选择 "Add Python to PATH" 选项
    echo    - 建议选择最新的Python 3.11或3.10版本
    echo.
    echo 🔄 安装完成后请重新运行此脚本
    echo.
    start https://www.python.org/downloads/
    pause
    exit /b 1
)

echo ✅ Python环境检测成功!
python --version
echo.

echo ============== 第2步: 检查pip工具和版本 ==============
echo.

python -m pip --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ pip工具异常！
    echo.
    echo 🔧 尝试修复pip...
    python -m ensurepip --upgrade
    
    if %errorlevel% neq 0 (
        echo ❌ pip修复失败，请重新安装Python
        pause
        exit /b 1
    )
)

echo ✅ pip工具检测成功!

REM 获取当前pip版本
for /f "tokens=2" %%i in ('python -m pip --version 2^>nul') do set current_pip_version=%%i
echo 📦 当前pip版本: %current_pip_version%

REM 检查pip版本是否足够新（这里设定最低版本要求为20.0）
python -c "import pip; exit(0 if tuple(map(int, pip.__version__.split('.'))) >= (20, 0, 0) else 1)" >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ pip版本满足要求，跳过升级
    goto :check_dependencies
)

echo ⚠️ pip版本较旧，建议升级以确保兼容性
set /p upgrade_pip="是否升级pip到最新版本？(Y/n): "
if /i "%upgrade_pip%"=="n" (
    echo 💡 跳过pip升级，继续使用当前版本
    goto :check_dependencies
)

echo 🔄 正在升级pip...
python -m pip install --upgrade pip

if %errorlevel% neq 0 (
    echo ⚠️ pip升级失败，继续使用当前版本
) else (
    echo ✅ pip升级成功!
    for /f "tokens=2" %%i in ('python -m pip --version 2^>nul') do set new_pip_version=%%i
    echo 📦 新pip版本: !new_pip_version!
)
echo.

:check_dependencies
echo ============== 第3步: 智能检查项目依赖 ==============
echo.

echo 📦 必需的依赖包:
echo    - pandas ^>= 1.3.0 (数据处理)
echo    - numpy ^>= 1.20.0 (数值计算)
echo    - tushare ^>= 1.2.89 (股票数据接口)
echo    - openpyxl ^>= 3.0.9 (Excel文件处理)
echo    - requests ^>= 2.25.0 (网络请求)
echo.

echo 🔍 检查现有依赖包...

REM 逐个检查关键包
set missing_packages=
set outdated_packages=

REM 检查pandas
python -c "import pandas; print('pandas:', pandas.__version__)" >nul 2>&1
if %errorlevel% neq 0 (
    set missing_packages=%missing_packages% pandas
    echo ❌ pandas: 未安装
) else (
    python -c "import pandas; exit(0 if tuple(map(int, pandas.__version__.split('.')[:2])) >= (1, 3) else 1)" >nul 2>&1
    if %errorlevel% neq 0 (
        set outdated_packages=%outdated_packages% pandas
        echo ⚠️ pandas: 版本过旧，需要升级
    ) else (
        echo ✅ pandas: 版本合适
    )
)

REM 检查numpy
python -c "import numpy; print('numpy:', numpy.__version__)" >nul 2>&1
if %errorlevel% neq 0 (
    set missing_packages=%missing_packages% numpy
    echo ❌ numpy: 未安装
) else (
    python -c "import numpy; exit(0 if tuple(map(int, numpy.__version__.split('.')[:2])) >= (1, 20) else 1)" >nul 2>&1
    if %errorlevel% neq 0 (
        set outdated_packages=%outdated_packages% numpy
        echo ⚠️ numpy: 版本过旧，需要升级
    ) else (
        echo ✅ numpy: 版本合适
    )
)

REM 检查tushare
python -c "import tushare; print('tushare:', tushare.__version__)" >nul 2>&1
if %errorlevel% neq 0 (
    set missing_packages=%missing_packages% tushare
    echo ❌ tushare: 未安装
) else (
    echo ✅ tushare: 已安装
)

REM 检查openpyxl
python -c "import openpyxl; print('openpyxl:', openpyxl.__version__)" >nul 2>&1
if %errorlevel% neq 0 (
    set missing_packages=%missing_packages% openpyxl
    echo ❌ openpyxl: 未安装
) else (
    echo ✅ openpyxl: 已安装
)

REM 检查requests
python -c "import requests; print('requests:', requests.__version__)" >nul 2>&1
if %errorlevel% neq 0 (
    set missing_packages=%missing_packages% requests
    echo ❌ requests: 未安装
) else (
    echo ✅ requests: 已安装
)

echo.

REM 如果没有缺失或过期的包，直接运行程序
if "%missing_packages%"=="" if "%outdated_packages%"=="" (
    echo 🎉 所有依赖包检查通过，无需安装!
    goto :run_program
)

REM 显示需要安装/升级的包
if not "%missing_packages%"=="" (
    echo 📋 需要安装的包:%missing_packages%
)
if not "%outdated_packages%"=="" (
    echo 📋 需要升级的包:%outdated_packages%
)

echo.
set /p confirm="是否现在安装/升级缺少的依赖包？(Y/n): "
if /i "%confirm%"=="n" (
    echo.
    echo 💡 您选择跳过依赖安装
    echo    请手动运行: pip install -r requirements.txt
    echo.
    pause
    exit /b 1
)

echo.
echo 📚 正在智能安装/升级依赖包...
echo.

REM 优先使用requirements.txt（如果存在）
if exist requirements.txt (
    echo 📄 检测到requirements.txt，使用批量安装...
    python -m pip install -r requirements.txt --upgrade
    
    if %errorlevel% equ 0 (
        echo ✅ 批量安装成功!
        goto :verify_installation
    )
    
    echo ⚠️ requirements.txt批量安装失败，尝试逐个安装...
)

REM 逐个安装/升级缺失的包
if not "%missing_packages%"=="" (
    echo 📦 安装缺失的包...
    for %%p in (%missing_packages%) do (
        echo   正在安装 %%p...
        if "%%p"=="pandas" python -m pip install "pandas>=1.3.0"
        if "%%p"=="numpy" python -m pip install "numpy>=1.20.0"
        if "%%p"=="tushare" python -m pip install "tushare>=1.2.89"
        if "%%p"=="openpyxl" python -m pip install "openpyxl>=3.0.9"
        if "%%p"=="requests" python -m pip install "requests>=2.25.0"
    )
)

if not "%outdated_packages%"=="" (
    echo 🔄 升级过期的包...
    for %%p in (%outdated_packages%) do (
        echo   正在升级 %%p...
        if "%%p"=="pandas" python -m pip install --upgrade "pandas>=1.3.0"
        if "%%p"=="numpy" python -m pip install --upgrade "numpy>=1.20.0"
        if "%%p"=="tushare" python -m pip install --upgrade "tushare>=1.2.89"
        if "%%p"=="openpyxl" python -m pip install --upgrade "openpyxl>=3.0.9"
        if "%%p"=="requests" python -m pip install --upgrade "requests>=2.25.0"
    )
)

:verify_installation
echo.
echo 🔍 最终依赖验证...
python -c "import pandas, numpy, tushare, openpyxl, requests; print('✅ 所有依赖检查通过!')" 2>nul
if %errorlevel% neq 0 (
    echo.
    echo ❌ 依赖安装验证失败！
    echo.
    echo 💡 故障排除建议:
    echo    1. 检查网络连接
    echo    2. 尝试使用国内镜像源:
    echo       pip install -i https://pypi.tuna.tsinghua.edu.cn/simple -r requirements.txt
    echo    3. 以管理员身份运行此脚本
    echo    4. 检查Python版本是否为3.7+
    echo.
    pause
    exit /b 1
)

echo ✅ 所有依赖验证通过!
echo.

:run_program
echo ============== 第4步: 运行报表生成器 ==============
echo.

if not exist run_bank_report.py (
    echo ❌ 未找到主程序文件 run_bank_report.py
    echo    请确保所有程序文件都在当前目录
    pause
    exit /b 1
)

if not exist config.py (
    echo ❌ 未找到配置文件 config.py
    echo    请确保 config.py 文件存在并包含有效的 TUSHARE_TOKEN
    pause
    exit /b 1
)

echo 🚀 启动银行股票分析报表生成器...
echo.
echo ⏱️  注意: 首次运行可能需要2-5分钟时间
echo    程序会获取所有银行股票的实时数据
echo.

python run_bank_report.py

echo.
echo ================================================
echo             程序执行完成
echo ================================================
echo.
echo 📊 如果程序成功运行，您应该看到:
echo    - Excel报表文件已生成
echo    - 文件名格式: 银行股票分析报表_YYYYMMDD_HHMMSS.xlsx
echo.

pause 