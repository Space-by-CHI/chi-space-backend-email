FROM python:3.12-slim AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# RUN curl -sSL https://install.python-poetry.org | python3 -
RUN python -m pip install poetry
ENV PATH="/root/.local/bin:$PATH"

COPY . .
#COPY pyproject.toml poetry.lock ./
#COPY README.md /app/
RUN ls -l /app
RUN poetry install --no-interaction --no-ansi

# Final stage
FROM python:3.12-slim

WORKDIR /app
COPY --from=builder /app /app
COPY . .

EXPOSE 8080
CMD ["poetry", "run", "python", "main.py"]