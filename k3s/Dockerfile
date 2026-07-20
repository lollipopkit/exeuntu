# exeuntu-k3s:预装 k3s + gVisor(runsc)的 exeuntu 变体,给 exe.dev VM 一键起 k3s 集群。
# 基于 exeuntu(systemd-in-VM + init-wrapper,exe.dev 可启动),故直接继承其启动机制。
# 一台机既可当 server 也可当 agent —— **不预 enable k3s.service**,角色/token 运行时定:
#   server: sudo k3s server            (RuntimeClass gvisor 由 auto-deploy manifest 启动时自动 apply)
#   agent:  sudo k3s agent --server https://<server>:6443 --token <token>
# 预烤 k3s/runsc 二进制 + containerd runsc drop-in → 起集群不再依赖(不稳的)VM 网络装包。
FROM ghcr.io/lollipopkit/exeuntu:latest

USER root
SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

# k3s 版本(tag 里的 + 在 URL 编码为 %2B)。amd64。
ARG K3S_RELEASE=v1.36.2%2Bk3s1

# k3s 二进制(air-gap:免首启拉 k3s 自身;pod 镜像仍按需拉)。
RUN curl -fsSL --retry 6 --retry-all-errors -o /usr/local/bin/k3s \
      "https://github.com/k3s-io/k3s/releases/download/${K3S_RELEASE}/k3s" \
 && chmod +x /usr/local/bin/k3s \
 && ln -sf /usr/local/bin/k3s /usr/local/bin/kubectl \
 && ln -sf /usr/local/bin/k3s /usr/local/bin/crictl

# gVisor runsc + containerd shim(直下二进制 + sha512 校验;exe.dev 上 gvisor.dev DNS 常挂,走 storage.googleapis.com)。
RUN cd /tmp \
 && U=https://storage.googleapis.com/gvisor/releases/release/latest/x86_64 \
 && for f in runsc runsc.sha512 containerd-shim-runsc-v1 containerd-shim-runsc-v1.sha512; do \
      curl -fsSL --retry 6 --retry-all-errors -o "$f" "$U/$f"; done \
 && sha512sum -c runsc.sha512 containerd-shim-runsc-v1.sha512 \
 && chmod a+rx runsc containerd-shim-runsc-v1 \
 && mv runsc containerd-shim-runsc-v1 /usr/local/bin/

# k3s 内嵌 containerd 接 runsc:drop-in(config.toml 的 imports 加载,不改生成的 config、重启存活)。
RUN mkdir -p /var/lib/rancher/k3s/agent/etc/containerd/config-v3.toml.d \
 && printf "[plugins.'io.containerd.cri.v1.runtime'.containerd.runtimes.runsc]\n  runtime_type = 'io.containerd.runsc.v1'\n" \
      > /var/lib/rancher/k3s/agent/etc/containerd/config-v3.toml.d/runsc.toml

# RuntimeClass gvisor:server 启动时经 auto-deploy manifests 自动 apply(集群级,一次即全节点可用)。
RUN mkdir -p /var/lib/rancher/k3s/server/manifests \
 && printf "apiVersion: node.k8s.io/v1\nkind: RuntimeClass\nmetadata:\n  name: gvisor\nhandler: runsc\n" \
      > /var/lib/rancher/k3s/server/manifests/gvisor-runtimeclass.yaml

# 回到默认用户(exeuntu 约定 lk)。CMD/init/label 全继承 exeuntu 基础镜像。
USER lk
