from django.shortcuts import render
import os
# from django.shortcuts import HttpResponse



def get_name(request):
    name = request.GET.get('name', 'world')
    return render(request, 'index.html', {'name': name})

def build(request):
    buildNumber = os.environ.get('buildNumber')
    return render(request, 'index.html', {'jenkins_variable': buildNumber})

def env(request):
    environment = os.environ.get('environment')
    return render(request, 'index.html', {'jenkins_variable': environment})