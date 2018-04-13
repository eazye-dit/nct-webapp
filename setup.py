#!/usr/bin/env python

from distutils.core import setup

setup(name='nct-webapp',
      version='0.2',
      description='NCTS web application',
      author='cn',
      author_email='lolexplode@gmail.com',
      packages=['webapp'],
      install_requires=['flask', 'flask-bootstrap', 'requests']
)
