*** Settings ***
Resource    ${CURDIR}/../resources/common.robot
Documentation    Create a new student with the provided parameters
Test Tags    api
Test Timeout    15 seconds
Suite Setup    test setup
Suite Teardown    test teardown
Test Template    Create New Student

*** Test Cases ***    JSON_FILE
Lower_case        TC_002_Test_Data.json
Upper_Case        TC_003_Test_Data.json


*** Keywords ***
Create New Student
    [Arguments]    ${data_file}
    
    ${json_sent}=    Load Json From File    ${CURDIR}/../resources/${data_file}    
    ${response}=    POST On Session  current_session  /api/studentsDetails  json=${json_sent}  headers=&{content_type_json}
    Should Be Equal As Integers    ${response.status_code}    201
    ${json_received}=  Convert String To Json    ${response.content}

    Log To Console    \n\nJSON SENT:\n${json_sent}
    Log To Console    \n\nJSON RECEIVED:\n${json_received}

    List Should Contain Sub List  ${json_received}    ${json_sent}
    
