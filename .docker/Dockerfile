FROM denoland/deno:1.42.1

WORKDIR /app

COPY . .
RUN deno cache src/main.ts

EXPOSE 8000

CMD ["deno", "run", "-A", "src/main.ts"]
