FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Shanghai \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

WORKDIR /app

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
        software-properties-common \
        build-essential \
        curl \
        wget \
        vim \
        lsof \
        procps \
        psmisc \
        iputils-ping \
        net-tools \
        telnet \
        ca-certificates \
        gnupg \
        lsb-release \
        git \
        tzdata && \
    add-apt-repository ppa:deadsnakes/ppa -y && \
    apt-get update && \
    apt-get install -y \
        python3.12 \
        python3.12-dev && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1 && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3.12 1 && \
    curl -sS https://bootstrap.pypa.io/get-pip.py | python3.12 - --break-system-packages && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /root/.pip && \
    echo '[global]' > /root/.pip/pip.conf && \
    echo 'index-url = https://pypi.tuna.tsinghua.edu.cn/simple' >> /root/.pip/pip.conf && \
    echo 'trusted-host = pypi.tuna.tsinghua.edu.cn' >> /root/.pip/pip.conf && \
    echo '[install]' >> /root/.pip/pip.conf && \
    echo 'trusted-host = pypi.tuna.tsinghua.edu.cn' >> /root/.pip/pip.conf

RUN python3 -m pip install --break-system-packages --upgrade pip setuptools wheel

RUN apt-get remove -y python3-blinker || true

RUN python3 -m pip install --break-system-packages \
        Flask \
        Flask-CORS \
        requests \
        gunicorn \
        python-dotenv \
        Jinja2 \
        Werkzeug

RUN python3 -m pip install --break-system-packages cryptography

RUN python3 -m pip cache purge

RUN mkdir -p /waxberry/attachment \
             /waxberry/sourcecode \
             /waxberry/resource \
             /waxberry/chathistory \
             /waxberry/tmp


RUN touch /waxberry/license

RUN cat > /waxberry/README.md << 'EOF'
# 名称

## 背景
阐述杨梅果研发背景，让使用者更好的理解当前产品。

## 应用场景
阐述该杨梅果的应用的领域、行业、范围。

## 使用说明
说明该杨梅果的使用方式，建议使用图表的形式加强用户的理解能力。

## 版本说明
杨梅果不同发布的版本及版本特性。

## 作者
作者信息

## 鸣谢
杨梅果的贡献者等，提供支持的小伙伴。

## FAQ
一些常见的基础问题的解答。
EOF

RUN cat > /waxberry/metadata.json << 'EOF'
{
  "name": "ExampleWaxberryApp",
  "identifier": "com.waxberry.app",
  "version": "1.0.0",
  "description": "这是一个示例应用，用于展示 metadata 的结构和内容。",
  "author": {
    "name": "示例开发者",
    "email": "dev@example.com",
    "website": "https://example.com"
  },
  "license": "MIT",
  "platform": {
    "os": ["linux", "windows", "macOS"],
    "architecture": "x64"
  },
  "documentation": {
    "userGuide": "https://example.com/user-guide",
    "apiDocs": "https://example.com/api-docs"
  },
  "repository": {
    "type": "git",
    "url": "https://github.com/example/app"
  },
  "keywords": [
    "示例",
    "metadata",
    "演示"
  ]
}
EOF

COPY waxberry-cli /opt/waxberry-cli
RUN chmod +x /opt/waxberry-cli

EXPOSE 80

ENTRYPOINT ["sh", "-c", "while true; do sleep 1; done"] 