# Waxberry Runtime

Waxberry Runtime 是一个基于微服务架构的开源平台，提供完整的运行时环境。该平台集成了多个核心服务，包括认证、网关、文件服务、插件系统等，为应用程序提供稳定可靠的运行时环境。

## 系统架构

系统由以下核心组件组成：

- **前端服务 (nginx)**: 提供静态资源服务和反向代理
- **认证服务 (auth)**: 处理用户认证和授权
- **网关服务 (gateway)**: API网关，统一入口点
- **核心服务 (core)**: 平台核心功能实现
- **插件服务 (plugin)**: 插件系统支持
- **文件服务 (fs)**: 文件存储和管理
- **沙箱服务 (sandbox)**: 提供安全的运行时环境
- **管理服务 (manager)**: 系统管理功能

### 基础设施

- **MySQL**: 数据存储
- **Redis**: 缓存服务
- **MinIO**: 对象存储服务

## 目录结构

```
.
├── apps/          # 应用程序目录
├── bin/           # 脚本目录
├── conf/          # 配置文件
├── data/          # 数据目录
├── logs/          # 日志目录
└── docker-compose.yml  # Docker编排配置
```

## 安装和部署

### 系统要求

- Docker
- Docker Compose
- Linux操作系统

### 部署步骤

1. **导入文件**
   ```bash
   sudo tar -zxf waxberry.tar.gz -C /
   ```

2. **安装Docker**
    - 确保已安装Docker和Docker Compose

3. **导入镜像**
   ```bash
   cd /waxberry/bin
   sudo ./service.sh load_images
   ```

4. **启动服务**
   ```bash
   cd /waxberry/bin
   sudo ./service.sh start
   ```

5. **验证部署**
    - 检查容器状态：
      ```bash
      sudo docker ps
      ```
    - 检查端口监听：
      ```bash
      sudo netstat -nltp
      ```
    - 访问系统：
      ```
      http://localhost (或服务器IP)
      ```

## 打包说明

### 打包步骤

1. 导出镜像：
   ```bash
   cd /waxberry/bin/
   ./service.sh export_images
   ```

2. 打包系统：
   ```bash
   ./service.sh package
   ```

## 服务端口

- 前端服务: 80
- MySQL: 3306
- Redis: 6379
- MinIO: 9000/9001
- 网关服务: 8000
- 认证服务: 9050
- 核心服务: 9040
- 插件服务: 9020
- 管理服务: 9030
- 文件服务: 9060
- 沙箱服务: 9010

## 许可证

本项目采用 Apache License 2.0 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。


