# =============================================================================
# VALENCE 2.0 PRODUCTION CONTAINER (Rust TCP Engine + Node Database Studio)
# =============================================================================

# Stage 1: Build high-performance Rust TCP engine
FROM rust:1.80-slim as builder
WORKDIR /app
COPY Cargo.toml Cargo.lock ./
COPY src ./src
RUN cargo build --release

# Stage 2: Runtime environment with Node.js Studio
FROM node:20-slim
WORKDIR /app

# Copy compiled Rust engine binary
COPY --from=builder /app/target/release/valence-server ./valence-server
RUN chmod +x ./valence-server

# Copy Studio and Consumer application assets
COPY valence_dashboard ./valence_dashboard
COPY public ./public
COPY server.js ./server.js
COPY README.md ./README.md

EXPOSE 8080
EXPOSE 6379
EXPOSE 3000

ENV PORT=8080
ENV VALENCE_HOST=127.0.0.1
ENV VALENCE_PORT=6379

# Launch compiled Rust engine on port 6379 and Studio on port $PORT
CMD ./valence-server & node valence_dashboard/server.js
