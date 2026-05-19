FROM public.ecr.aws/docker/library/postgres:18-alpine

CMD ["postgres", "-c", "max_locks_per_transaction=256"]
