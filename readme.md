# Rest API testing With Robot Framework & Python


## EXECUTION
Run single test:
- robot --outputdir results  tests/TC_001_Get_Request.robot
run whole folder:
- robot --outputdir results  tests

Parallel execution
- pabot tests/TC_001_Get_Request.robot
- pabot --testlevelsplit  tests

## REQUIREMENTS
python 3.12.4

## PIP LIST (installed python packages)##
- attrs                      24.2.0
- certifi                    2024.7.4
- charset-normalizer         3.3.2
- idna                       3.7
- jsonpath-ng                1.6.1
- jsonschema                 4.23.0
- jsonschema-specifications  2023.12.1
- natsort                    8.4.0
- pip                        24.2
- ply                        3.11
- referencing                0.35.1
- requests                   2.32.3
- robot                      20071211
- robotframework             7.0.1
- robotframework-jsonlibrary 0.5
- robotframework-pabot       2.18.0
- robotframework-requests    0.9.7
- robotframework-stacktrace  0.4.1
- rpds-py                    0.20.0
- urllib3                    2.2.2
