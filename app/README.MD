# Optimized Python Dockerfile

This repository contains an optimized and production-ready Dockerfile for running a Python application. The original Dockerfile was improved to address **security, performance, and image size concerns**.

---

##  Issues in Original Dockerfile

The initial Dockerfile had several problems:

* Used `ubuntu:latest` (unpredictable and large)
* Installed Python manually via `apt` (unnecessary)
* Python requirements.txt packages has no versions specified
* No cleanup of package manager cache
* Ran container as root (security risk)
* No working directory defined
* Inefficient dependency installation
* No production-grade application server
* Used privileged port (80)
* No logging optimization
* Potential for large image size

---

##  Improvements Implemented

### 1. Use Minimal Base Image

* Switched to `python:3.11-slim`
* Reduces image size and attack surface
* Ensures reproducibility

---

### 2. Removed Unnecessary Package Installation

* Avoided installing Python via `apt`
* Used prebuilt Python runtime from base image

---

### 3. Optimized Dependency Installation

* Used:

```bash
pip install --no-cache-dir -r requirements.txt
```

* Prevents caching → smaller image

---

### 4. Added Working Directory

```dockerfile
WORKDIR /app
```

* Keeps filesystem organized and predictable

---

### 5. Added Non-Root User (Security Best Practice)

```dockerfile
RUN useradd -m appuser
USER appuser
```

* Prevents privilege escalation risks

---

### 6. Enabled Production Logging

```dockerfile
ENV PYTHONUNBUFFERED=1
```

* Ensures real-time logs (important for Docker/Kubernetes)

---

### 7. Disabled Bytecode Generation

```dockerfile
ENV PYTHONDONTWRITEBYTECODE=1
```

* Reduces unnecessary file creation

---

### 8. Switched to Non-Privileged Port

```dockerfile
EXPOSE 8000
```

* Avoids requiring root privileges

---

### 9. Used Production WSGI Server

* Replaced:

```bash
python app.py
```

* With:

```bash
gunicorn app.py
```
