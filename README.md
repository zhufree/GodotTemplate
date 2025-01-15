# Godot通用模板项目

这是一个基于Godot引擎的通用游戏模板项目，提供了常用的基础功能实现，帮助开发者快速开始新的游戏项目开发。

## 项目结构

```
CommonTemplate/
├── assets/                 # 资源文件夹
├── global.gd              # 全局单例脚本
├── saved_game.gd         # 存档系统实现
├── setting.gd            # 游戏设置管理
├── main.tscn            # 主场景
├── start.tscn           # 开始菜单场景
└── credit.tscn          # 制作人员名单场景
```

## 核心功能

### 1. 全局状态管理
- 使用`global.gd`作为自动加载的单例
- 管理全局游戏状态
- 处理音量设置
- 管理存档数据

### 2. 存档系统
- 基于Godot的Resource系统实现
- 支持关卡进度保存
- 支持物品栏数据保存
- 自动保存功能

### 3. 设置系统
- 音乐音量调节
- 音效音量调节
- 设置数据持久化

### 4. 基础场景
- 主菜单场景
- 游戏主场景
- 制作人员名单场景

### 5. 国际化支持
- 使用CSV文件进行多语言翻译
- 支持多语言切换

## 如何使用

1. 克隆此仓库作为新项目的起点
2. 根据需要修改场景和脚本
3. 在`global.gd`中添加需要的全局变量
4. 在`saved_game.gd`中扩展存档数据结构

## 依赖
- Godot 4.x
- GDScript
