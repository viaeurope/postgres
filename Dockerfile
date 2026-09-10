FROM public.ecr.aws/docker/library/postgres:18-alpine

# Build pgvector from source
# DOCKER_PG_LLVM_DEPS exposes clang21, which isnt included in build-base
# OPTFLAGS="" for portability

ARG PGVECTOR_VERSION=0.8.2

RUN apk add --no-cache --virtual .pgvector-build-deps \
    build-base \
    $DOCKER_PG_LLVM_DEPS \
    git \
    && git clone --branch "v${PGVECTOR_VERSION}" --depth 1 \
    https://github.com/pgvector/pgvector.git /tmp/pgvector \
    && make -C /tmp/pgvector OPTFLAGS="" \
    && make -C /tmp/pgvector install \
    && rm -rf /tmp/pgvector \
    && apk del .pgvector-build-deps

CMD ["postgres", "-c", "max_locks_per_transaction=256"]
