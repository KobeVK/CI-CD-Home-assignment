from django.shortcuts import render
import os

def get_name(request):
    name = request.GET.get('name', 'world')
    return render(request, 'index.html', {'name': name})

def build_number(request):
    buildNum = os.getenv('BUILD_NUMBER')
    return render(request, 'index.html', buildNum)

def env(request):
    envioronment = os.getenv('ENVIRONMENT')
    return render(request, 'index.html', envioronment)

