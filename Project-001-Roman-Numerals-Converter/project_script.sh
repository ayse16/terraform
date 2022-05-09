#! /bin/bash
            yum update -y
            pip3 install flask
            cd /home/ec2-user
            FOLDER="https://raw.githubusercontent.com/ayse16/my_projects/main/Project-001-Roman-Numerals-Converter"
            wget ${FOLDER}/app.py
            mkdir templates
            wget ${FOLDER}/templates/index.html
            mv index.html templates
            wget ${FOLDER}/templates/result.html
            mv result.html templates
            python3 app.py