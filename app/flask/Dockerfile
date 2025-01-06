# Using an official Python runtime as a parent image
FROM python:3.9-slim

# Setting working directory
WORKDIR /app

# Copying only the requirements file first to leverage Docker cache
COPY requirements.txt /app/requirements.txt

# Installing dependencies without caching to minimize image size
RUN pip install --no-cache-dir -r /app/requirements.txt

# Copying the rest of the application code into the container
COPY . /app

# Exposing the application's port
EXPOSE 5001

# Running the application
CMD ["python", "app.py"]
