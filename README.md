# 离屏资源指示器 (Off-Screen Resource Indicators)

这是一个为《穹顶守护者》(Dome Keeper) 游戏开发的模组，用于显示离屏资源的位置指示器。当资源不在屏幕视野内时，会在屏幕边缘显示指向该资源的箭头指示器，帮助玩家更容易找到各种资源。

## 功能

- 为各种资源类型提供离屏指示器，包括：
  - 各类矿洞（钴矿、铁矿树、蘑菇洞等）
  - 水、铁、钴、种子、炸弹等可收集资源
  - 遗物、能量核心等特殊物品

- 智能显示系统：
  - 只有当资源不在屏幕内且资源可用时才显示指示器
  - 根据资源类型显示不同图标
  - 可通过配置文件自定义显示选项

- 完全可配置：
  - 可单独开启/关闭每种资源类型的指示器
  - 支持调试信息显示

## 自动安装
1. 访问[Steam创意工坊页面](https://steamcommunity.com/sharedfiles/filedetails/?id=3524099344)
2. 订阅本模组
3. 启动游戏，在模组菜单中启用本模组

## 手动安装

1. 确保已安装 [r-modloader](https://github.com/GodotModding/godot-mod-loader)
2. 将本模组文件夹放入游戏的 `mods-unpacked` 目录中
3. 启动游戏，在模组菜单中启用本模组

## 配置选项

1. 打开模组配置文件目录：`%APPDATA%\Godot\app_userdata\Dome Keeper\mod_configs\Abevol-OffScreenResourceIndicators`
2. 在配置文件`default.json`中，你可以找到以下配置选项：

- 显示调试信息：显示资源类型和状态的文本信息
- 各种资源类型的开关：可以单独控制每种资源类型的指示器显示

## 技术实现

本模组使用 Godot 的脚本扩展和钩子系统实现功能：

- 使用 `HookManager` 集中管理所有钩子回调
- 通过脚本扩展为原游戏对象添加指示器功能
- 使用资源状态跟踪系统确保指示器正确显示

## 项目结构

```
Abevol-OffScreenResourceIndicators/
├── manifest.json         # 模组清单文件
├── mod_main.gd           # 模组主入口脚本
├── hook_manager.gd       # 钩子管理器
├── .gdlintrc             # GDScript 代码风格检查配置
├── file_watcher.gd       # 文件监视器
├── constants.gd          # 常量定义
├── content/              # 模组内容
├── translations/         # 翻译文件
└── extensions/           # 脚本扩展
```

## 贡献

欢迎提交问题报告和改进建议！如果你想贡献代码，请遵循以下步骤：

1. Fork 本仓库
2. 创建你的功能分支 (`git checkout -b feature/amazing-feature`)
3. 提交你的更改 (`git commit -m 'Add some amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 打开一个 Pull Request

## 许可证

本项目采用 MIT 许可证 - 详情请参阅 LICENSE 文件

## 致谢

- 感谢《穹顶守护者》的开发团队创造了这款优秀的游戏
- 感谢 r-modloader 团队提供的模组加载框架 