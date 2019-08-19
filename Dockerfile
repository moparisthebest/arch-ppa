FROM archlinux/base:latest AS build

ARG PKGS_TO_BUILD_IN_ORDER
ENV PKGS_TO_BUILD_IN_ORDER=$PKGS_TO_BUILD_IN_ORDER

# Install tools required for project
# Run `docker build --no-cache .` to update dependencies
RUN mkdir -p /build/ /repo/ /var/cache/pacman/pkg/ && chown nobody: /build/ /repo/ && \
    echo -e '[aur]\nSigLevel = Never\nServer = file:///repo' >> /etc/pacman.conf && repo-add /repo/aur.db.tar.gz && \
    echo 'COMPRESSXZ=(xz -c -z - --threads=0)' >> /etc/makepkg.conf && \
    pacman -Syu --noconfirm sudo base-devel && \
    echo -e 'nobody  ALL= NOPASSWD: /usr/bin/pacman\nnobody  ALL= NOPASSWD: /usr/bin/makepkg' > /etc/sudoers.d/nobody

COPY . /build/
WORKDIR /build/src/

RUN chown -R nobody: /build/ /repo/ && /build/.docker/build.sh /build/src /repo

# This results in a single layer image
FROM nginx:stable-alpine
COPY --from=build /repo/ /usr/share/nginx/html
RUN rm /usr/share/nginx/html/index.html /usr/share/nginx/html/50x.html && chown -R nginx: /usr/share/nginx/html && \
    sed -i 's@root   /usr/share/nginx/html;@root   /usr/share/nginx/html;  autoindex on;@' /etc/nginx/conf.d/default.conf
