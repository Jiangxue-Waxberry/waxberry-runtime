# Waxberry Runtime

Waxberry Runtime is an open-source platform based on microservice architecture, providing a complete runtime environment. The platform integrates multiple core services, including authentication, gateway, file service, plugin system, and more, offering a stable and reliable runtime environment for applications.

## System Architecture

The system consists of the following core components:

- **Frontend Service (nginx)**: Provides static resource service and reverse proxy
- **Authentication Service (auth)**: Handles user authentication and authorization
- **Gateway Service (gateway)**: API gateway, unified entry point
- **Core Service (core)**: Platform core functionality implementation
- **Plugin Service (plugin)**: Plugin system support
- **File Service (fs)**: File storage and management
- **Sandbox Service (sandbox)**: Provides secure runtime environment
- **Management Service (manager)**: System management functionality

### Infrastructure

- **MySQL**: Data storage
- **Redis**: Caching service
- **MinIO**: Object storage service

## Directory Structure

```
.
├── apps/          # Application directory
├── bin/           # Script directory
├── conf/          # Configuration files
├── data/          # Data directory
├── images/        # Docker images
├── init-scripts/  # Initialization scripts
├── logs/          # Log directory
└── docker-compose.yml  # Docker orchestration configuration
```

## Installation and Deployment

### Requirements

- Docker
- Docker Compose
- Linux operating system

### Deployment Steps

1. **Import Files**
   ```bash
   sudo tar -zxf waxberry.tar.gz -C /
   ```

2. **Install Docker**
  - Ensure Docker and Docker Compose are installed

3. **Import Images**
   ```bash
   cd /waxberry/bin
   sudo ./service.sh load_images
   ```

4. **Start Services**
   ```bash
   cd /waxberry/bin
   sudo ./service.sh start
   ```

5. **Verify Deployment**
  - Check container status:
    ```bash
    sudo docker ps
    ```
  - Check port listening:
    ```bash
    sudo netstat -nltp
    ```
  - Access system:
    ```
    http://localhost (or server IP)
    ```

## Packaging Instructions

### Packaging Steps

1. Export images:
   ```bash
   cd /waxberry/bin/
   ./service.sh export_images
   ```

2. Package system:
   ```bash
   ./service.sh package
   ```

## Service Ports

- Frontend Service: 80
- MySQL: 3306
- Redis: 6379
- MinIO: 9000/9001
- Gateway Service: 8000
- Authentication Service: 9050
- Core Service: 9040
- Plugin Service: 9020
- Management Service: 9030
- File Service: 9060
- Sandbox Service: 9010

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.


