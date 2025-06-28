#!/bin/bash

BASE_DIR=$(dirname "$(dirname "$(realpath "$0")")")
DOCKER_COMPOSE_CMD=""

function check_docker_compose() {
    if command -v docker-compose &> /dev/null; then
        DOCKER_COMPOSE_CMD="docker-compose"
    elif command -v docker &> /dev/null && docker compose &> /dev/null; then
        DOCKER_COMPOSE_CMD="docker compose"
    else
        echo "Error: docker-compose is not installed. Please install it and retry."
        exit 1
    fi
}

function start_app() {
    check_docker_compose
    if [ -z "$1" ]; then
        $DOCKER_COMPOSE_CMD up -d
    else
        $DOCKER_COMPOSE_CMD up -d $1
    fi
}

function stop_app() {
    check_docker_compose
    if [ -z "$1" ]; then
        $DOCKER_COMPOSE_CMD down
    else
        $DOCKER_COMPOSE_CMD stop $1
    fi
}

function uninstall_app() {
    check_docker_compose
    local remove_volumes=""
    if [ "$2" == "--remove-volumes" ] || [ "$2" == "-v" ]; then
        remove_volumes="-v"
    fi

    if [ -z "$1" ]; then
        $DOCKER_COMPOSE_CMD down $remove_volumes
    else
        $DOCKER_COMPOSE_CMD stop $1
        $DOCKER_COMPOSE_CMD rm -f $1
        if [ ! -z "$remove_volumes" ]; then
            docker volume prune -f
        fi
    fi
}

function rebuild_app() {
    check_docker_compose
    if [ -z "$1" ]; then
        echo "Please specify a service to rebuild."
        exit 1
    else
        $DOCKER_COMPOSE_CMD up -d --build $1
    fi
}

function export_docker_images() {
    check_docker_compose
    images_dir="$BASE_DIR/images" # 使用基础目录
    mkdir -p "$images_dir"
    echo "Exporting Docker images to $images_dir ..."

    (cd "$BASE_DIR" && $DOCKER_COMPOSE_CMD config | grep "image:" | awk '{ print $2 }' | sort -u | while read image; do
        image_name=$(echo $image | tr "/" "_" | tr ":" "-")
        docker save $image -o "$images_dir/${image_name}.tar"
        echo "Exported $image to $images_dir/${image_name}.tar"
    done)
    docker save waxberry:latest -o "$images_dir/waxberry-latest.tar"
    echo "Exported waxberry:latest to $images_dir/waxberry-latest.tar"
    echo "All images exported to $images_dir."
}
function export_docker_images_x8664() {
    check_docker_compose
    images_dir="$BASE_DIR/images" # 使用基础目录
    mkdir -p "$images_dir"
    echo "Exporting Docker images to $images_dir ..."

    (cd "$BASE_DIR" && $DOCKER_COMPOSE_CMD config | grep "image:" | awk '{ print $2 }' | sort -u | while read image; do
        image_name=$(echo $image | tr "/" "_" | tr ":" "-")

        # 拉取指定平台的镜像
        echo "Pulling image $image for platform linux/amd64..."
        docker pull --platform linux/amd64 $image

        # 导出镜像到指定目录
        docker save $image -o "$images_dir/${image_name}.tar"
        echo "Exported $image to $images_dir/${image_name}.tar"
    done)
    echo "All images exported to $images_dir."
}
function package_app() {
    base_parent_dir=$(dirname "$BASE_DIR")
    app_dir_name=$(basename "$BASE_DIR")
    output_file="./$app_dir_name/waxberry.tar.gz"

    echo "Packaging application into $output_file..."
    (cd "$base_parent_dir" && tar --exclude="waxberry.tar.gz"  --exclude="./$app_dir_name/data" --exclude="./$app_dir_name/logs" -cvzf "$output_file" "./$app_dir_name")
    echo "Application packaged as $output_file"
}

function load_docker_images() {
    images_dir="$BASE_DIR/images"
    if [ -d "$images_dir" ]; then
        echo "Loading Docker images from $images_dir..."
        for image_file in "$images_dir"/*.tar; do
            if [ -f "$image_file" ]; then
                docker load -i "$image_file"
                echo "Loaded image $image_file"
            fi
        done
    fi
}

function export_docker_image() {
    check_docker_compose
    if [ -z "$2" ]; then
        echo "Error: Please specify an image name."
        echo "Usage: $0 export_image <image_name>"
        exit 1
    fi

    images_dir="$BASE_DIR/images"
    mkdir -p "$images_dir"
    image="$2"
    
    echo "Exporting Docker image $image to $images_dir ..."
    
    echo "Pulling image $image for platform linux/amd64..."
    docker pull --platform linux/amd64 $image
    
    image_name=$(echo $image | tr "/" "_" | tr ":" "-")
    
    docker save $image -o "$images_dir/${image_name}.tar"
    echo "Exported $image to $images_dir/${image_name}.tar"
}

function build_docker_image() {
    local platform="linux/amd64"
    local tag="waxberry:latest"
    local build_dir="$BASE_DIR/docker"
    local dockerfile="Dockerfile"
    
    # 解析参数
    while [[ $# -gt 0 ]]; do
        case $1 in
            --platform)
                platform="$2"
                shift 2
                ;;
            --tag|-t)
                tag="$2"
                shift 2
                ;;
            --build-dir)
                build_dir="$2"
                shift 2
                ;;
            --dockerfile|-f)
                dockerfile="$2"
                shift 2
                ;;
            *)
                shift
                ;;
        esac
    done
    
    # 检查构建目录是否存在
    if [ ! -d "$build_dir" ]; then
        echo "Error: Build directory $build_dir does not exist."
        exit 1
    fi
    
    # 检查Dockerfile是否存在
    if [ ! -f "$build_dir/$dockerfile" ]; then
        echo "Error: Dockerfile $build_dir/$dockerfile does not exist."
        exit 1
    fi
    
    echo "Building Docker image..."
    echo "Platform: $platform"
    echo "Tag: $tag"
    echo "Build directory: $build_dir"
    echo "Dockerfile: $dockerfile"
    echo ""
    
    (cd "$build_dir" && docker build --platform "$platform" -t "$tag" -f "$dockerfile" .)
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ Docker image built successfully: $tag"
    else
        echo ""
        echo "❌ Failed to build Docker image"
        exit 1
    fi
}

case "$1" in
    start)
        start_app $2
        ;;
    stop)
        stop_app $2
        ;;
    uninstall)
        uninstall_app $2 $3
        ;;
    rebuild)
        rebuild_app $2
        ;;
    build)
        shift
        build_docker_image "$@"
        ;;
    export_images)
        export_docker_images
        ;;
    export_images_x8664)
        export_docker_images_x8664
        ;;
    load_images)
	      load_docker_images
        ;;
    package)
        package_app
        ;;
    export_image)
        export_docker_image $1 $2
        ;;
    *)
        echo "Usage:"
        echo "$0 start [service_name]"
        echo "$0 stop [service_name]"
        echo "$0 uninstall [service_name] [--remove-volumes|-v]"
        echo "$0 rebuild service_name"
        echo "$0 build [--platform <platform>] [--tag|-t <tag>] [--build-dir <dir>] [--dockerfile|-f <file>]"
        echo "$0 export_images"
        echo "$0 export_images_x8664"
        echo "$0 load_images"
        echo "$0 package"
        echo "$0 export_image <image_name>"
        exit 1
esac
