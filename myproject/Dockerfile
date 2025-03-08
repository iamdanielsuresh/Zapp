# Use Python 3.10 as base image  
FROM python:3.10  

# Set the working directory in the container  
WORKDIR /myproject  

# Copy project files  
COPY . .  

# Install dependencies  
RUN pip install --no-cache-dir -r requirements.txt  

# Run migrations and collect static files  
RUN python manage.py migrate  
RUN python manage.py collectstatic --noinput  

# Expose port 8000  
EXPOSE 8000  

# Start Django with Gunicorn  
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "myproject.wsgi:application"]
