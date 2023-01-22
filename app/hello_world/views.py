from django.shortcuts import render
import os

def get_name(request):
    name = request.GET.get('name', 'world')
    return render(request, 'index.html', {'name': name})

def build(request):
    buildNumber = os.getenv('buildNumber')
    return render(request, 'index.html', {'jenkins_variable': buildNumber})

def env(request):
    environment = os.getenv('environment')
    return render(request, 'index.html', {'jenkins_variable': environment})