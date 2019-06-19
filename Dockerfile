FROM opensuse/leap:15.1

RUN zypper --non-interactive addrepo https://download.opensuse.org/repositories/Virtualization:containers/openSUSE_Leap_15.1/Virtualization:containers.repo
RUN zypper --gpg-auto-import-keys refresh
RUN zypper --non-interactive install \
  bind-utils \
  curl \
  docker \
  gcc \
  git \
  gzip \
  jq \
  make \
  python \
  python2-pip \
  ruby \
  unzip \
  vim \
  zip

RUN pip install --upgrade pip && \
    pip install yq

RUN curl -fsL https://download.docker.com/linux/static/stable/x86_64/docker-18.09.6.tgz | tar -xz -C /tmp/ && \
    cp /tmp/docker/docker /usr/bin/docker && \
    rm -rf /tmp/docker

RUN curl -fsL https://storage.googleapis.com/kubernetes-helm/helm-v2.13.1-linux-amd64.tar.gz | tar -xzf - -C /tmp linux-amd64/helm && \
    mv /tmp/linux-amd64/helm /usr/bin/helm && \
    rm -rf /tmp/linux-amd64/

ADD https://github.com/kubernetes-sigs/kind/releases/download/v0.3.0/kind-linux-amd64 /usr/bin/kind
RUN chmod +x /usr/bin/kind

ADD https://storage.googleapis.com/kubernetes-release/release/v1.14.0/bin/linux/amd64/kubectl /usr/bin/kubectl
RUN chmod +x /usr/bin/kubectl

ADD https://github.com/SUSE/kctl/releases/download/v0.0.12/kctl-linux-amd64 /usr/bin/k
RUN chmod +x /usr/bin/k

ENV GOPATH /go
ENV PATH $GOPATH/bin:$PATH

RUN curl -fsL https://dl.google.com/go/go1.12.2.linux-amd64.tar.gz | tar -xz -C /opt && \
    update-alternatives --install "/usr/bin/go" "go" "/opt/go/bin/go" 1 && \
    update-alternatives --install "/usr/bin/gofmt" "gofmt" "/opt/go/bin/gofmt" 1

RUN go get -u golang.org/x/lint/golint && \
    go get github.com/onsi/ginkgo/ginkgo && \
    go get github.com/onsi/gomega/... && \
    go get github.com/rohitsakala/goveralls && \
    go get github.com/modocache/gover

RUN gem install bosh-template
