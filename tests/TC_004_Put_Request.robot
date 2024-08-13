*** Settings ***
Resource    ${CURDIR}/../resources/common.robot


*** Test Cases ***
TC_004_Validate_Put_Request

    [Documentation]    Create a new student then update it
    [Tags]    api
    [Setup]    test setup
    [Teardown]    test teardown
    [Timeout]    15 seconds

    ${test_data_json}=    Load Json From File    ${CURDIR}/../resources/TC_004_Test_Data.json
    ${create_student_json}=    Get From Dictionary    ${test_data_json}    CreateData
    ${update_student_json}=    Get From Dictionary    ${test_data_json}    UpdateData

    #create new student
    ${post_response}=    POST On Session  current_session  /api/studentsDetails  json=${create_student_json}  headers=&{content_type_json}
    Should Be Equal As Integers    ${post_response.status_code}    201
    ${post_response_json}=  Convert String To Json    ${post_response.content}
    ${create_IDs}=    Get Value From Json    ${post_response_json}    $..id
    ${create_ID}=    Get Variable Value    ${create_IDs[0]}
    ${get_response}=    GET On Session    current_session    /api/studentsDetails/${create_ID}
    Should Be Equal As Integers    ${get_response.status_code}    200
    
    #update student
    Set To Dictionary    ${update_student_json}    id=${create_ID}
    ${put_response}=    PUT On Session    current_session   /api/studentsDetails/${create_ID}    json=${update_student_json}    headers=&{content_type_json}
    Log To Console    PUT RESPONSE: ${put_response.content}
    Should Be Equal As Integers    ${put_response.status_code}    200
    ${put_response_json}=    Convert String To Json    ${put_response.content}
    ${put_status}=    Get Value From Json    ${put_response_json}    status
    Should Be Equal As Strings    ${put_status[0]}    true
    
    #validate
    ${get_response}=    GET On Session    current_session    /api/studentsDetails/${create_ID}
    Should Be Equal As Integers    ${get_response.status_code}    200
    ${get_request_json}=    Convert String To Json    ${get_response.content}
    ${updated_json}=    Get Value From Json    ${get_request_json}    $..data
    Dictionaries Should Be Equal    ${update_student_json}    ${updated_json[0]}