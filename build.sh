#!/bin/bash

# 当任何命令失败时，立即退出脚本
set -e
# 如果管道中的任何一个命令失败，则整个管道的退出码为非零
set -o pipefail

# --- 配置区 ---
# 请在此处修改你的项目名前缀
ZIP_NAME_PREFIX="ShutdownTimer"

# --- 脚本区 ---

# 检查必要的命令是否存在
check_command() {
    if ! command -v "$1" &>/dev/null; then
        echo "错误: 命令 '$1' 未找到。请确保已安装并配置在系统 PATH 中。"
        exit 1
    fi
}

# 检查 git 和 flutter 命令
check_command "git"
check_command "flutter"

echo "✅ 依赖检查通过。"

# --- 1. 检测操作系统并设置平台特定变量 ---
PLATFORM_NAME=""
FLUTTER_BUILD_CMD=""
SOURCE_DIR=""

case "$(uname -s)" in
Linux*)
    PLATFORM_NAME="linux-x64"
    FLUTTER_BUILD_CMD="flutter build linux --release"
    SOURCE_DIR="build/linux/x64/release/bundle"
    ;;
Darwin*)
    PLATFORM_NAME="macos-universal"
    FLUTTER_BUILD_CMD="flutter build macos --release"
    SOURCE_DIR="build/macos/Build/Products/Release"
    ;;
CYGWIN* | MINGW* | MSYS*)
    PLATFORM_NAME="windows-x64"
    FLUTTER_BUILD_CMD="flutter build windows --release"
    SOURCE_DIR="build/windows/x64/runner/Release"
    ;;
*)
    echo "不支持的操作系统: $(uname -s)"
    exit 1
    ;;
esac

if [ "$COMPATIBLE_SYSTEM" = "TRUE" ] || [ "$COMPATIBLE_SYSTEM" = "true" ]; then
    PLATFORM_NAME="${PLATFORM_NAME}-compatible"
fi

echo "🚀 检测到平台: ${PLATFORM_NAME}"

# --- 2. 获取 Git 信息 ---
echo "ℹ️  正在获取 Git 信息..."
BRANCH=$(git branch --show-current)
COMMIT_SHORT_HASH=$(git rev-parse --short HEAD)
# 获取最新的 tag，如果没有 tag，则使用 'unknown'
BUILD_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo 'unknown')
BUILD_TAG_LATEST=$(git tag --sort=-creatordate | head -n 1 || echo 'unknown')

if [ -z "$BRANCH" ]; then
    echo "⚠️  警告: 无法获取当前 Git 分支名。可能处于 'detached HEAD' 状态。"
    # 在 CI/CD 环境中，可能没有分支名，可以尝试从环境变量中获取
    BRANCH=${CI_COMMIT_REF_NAME:-"detached"}
fi

echo "  - 分支: ${BRANCH}"
echo "  - Tag: ${BUILD_TAG} "
echo "  - Tag Latest: ${BUILD_TAG_LATEST}"
echo "  - Commit: ${COMMIT_SHORT_HASH}"

# --- 3. 构建 ZIP 文件名 ---
# 根据分支名决定最终的文件名结构
GIT_PART=""
if [ "$BUILD_TAG" = "unknown" ]; then
    # 清理分支名中的斜杠，替换为下划线，例如 feature/login -> feature_login
    SAFE_BRANCH_NAME=$(echo "$BRANCH" | sed 's/\//_/g')
    GIT_PART="${SAFE_BRANCH_NAME}-${COMMIT_SHORT_HASH}"
else
    GIT_PART="${BUILD_TAG}-${COMMIT_SHORT_HASH}"
fi

# 拼接成最终的文件名，格式：XXXX-windows-x64--v1.5.4.1-347fd25.zip
ZIP_FILENAME="${ZIP_NAME_PREFIX}-${PLATFORM_NAME}-${GIT_PART}.zip"
echo "📦 准备打包为: ${ZIP_FILENAME}"

# --- 4. 创建输出目录 ---
BIN_DIR="dist"
mkdir -p "$BIN_DIR"
# 获取当前工作目录的绝对路径，以便后续使用
CWD=$(pwd)
FINAL_ZIP_PATH="${CWD}/${BIN_DIR}/${ZIP_FILENAME}"

# --- 5. 执行 Flutter 构建 ---
echo "🛠️  开始执行 Flutter 构建命令: '${FLUTTER_BUILD_CMD}'"
# (可选) 在构建前清理
# flutter clean
eval "$FLUTTER_BUILD_CMD"
echo "✅ Flutter 构建完成。"

# --- 6. 打包产物 ---
echo "⚙️  正在打包产物..."
if [ ! -d "$SOURCE_DIR" ]; then
    echo "错误: 构建产物目录 '${SOURCE_DIR}' 不存在。构建可能已失败。"
    exit 1
fi

# 使用 pushd 和 popd 安全地切换目录进行压缩
# 这样可以确保 zip 包内的文件没有多余的父级目录结构
pushd "$SOURCE_DIR" >/dev/null

if [[ "$(uname -s)" == "Darwin"* ]]; then
    # 对于 macOS，我们只打包 .app 文件
    # 找到目录中唯一的 .app 文件
    APP_BUNDLE=$(find . -name "*.app" -maxdepth 1)
    if [ -z "$APP_BUNDLE" ]; then
        echo "错误: 在 '${SOURCE_DIR}' 中未找到 .app 文件。"
        popd >/dev/null
        exit 1
    fi
    echo "  - 正在为 macOS 打包: ${APP_BUNDLE}"
    # -r 递归压缩目录（.app 是一个目录），-q 静默模式，-y 保留符号链接
    zip -r -q -y "${FINAL_ZIP_PATH}" "${APP_BUNDLE}"
else
    # 对于 Linux 和 Windows，打包整个 bundle/Release 目录的内容
    echo "  - 正在为 ${PLATFORM_NAME} 打包所有产物..."
    zip -r -q "${FINAL_ZIP_PATH}" .
fi

popd >/dev/null

# --- 7. 完成 ---
echo "🎉 打包成功！"
echo "✅ 产物已保存至: ${FINAL_ZIP_PATH}"
