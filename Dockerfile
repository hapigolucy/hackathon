# Stage 1: Build React app
FROM node:18-alpine AS frontend
WORKDIR /app/frontend
RUN pwd
COPY ./frontend/package*.json ./
RUN npm install
COPY ./frontend/ ./
RUN npm run build

# Stage 2: Build Python app (without virtual environment)
FROM python:3.11-slim AS backend
WORKDIR /app/backend
COPY ./backend/requirements.txt /app/backend/requirements.txt
# RUN pip install --no-cache-dir --break-system-packages fastapi uvicorn
RUN pip install --no-cache-dir --break-system-packages -r /app/backend/requirements.txt
COPY ./backend/ ./
EXPOSE 8000

# Stage 3: Final stage to run both Nginx and Uvicorn
FROM nginx:alpine
RUN apk add --no-cache python3 py3-pip
COPY ./backend/requirements.txt /app/backend/requirements.txt
RUN pip install --no-cache-dir --break-system-packages -r /app/backend/requirements.txt
COPY --from=backend /app/backend /app/backend
COPY --from=frontend /app/frontend/build /usr/share/nginx/html
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
WORKDIR /app/backend
RUN pwd

# Run both Uvicorn (FastAPI) and Nginx
CMD ["sh", "-c", "python3 -m uvicorn main:app --host 0.0.0.0 --port 8000 & nginx -g 'daemon off;'"]
